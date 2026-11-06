"""Independent finite oracle for AdmissionReplay. No assertions erased by -O."""
from copy import deepcopy
from itertools import product


def require(condition, message):
    if not condition:
        raise ValueError(message)


def step(state, event):
    out = deepcopy(state)
    if event['kind'] == 'datum':
        out['data'] += 1
    elif event['kind'] == 'form':
        if event['arity'] < 1:
            return None
        out['forms'].append(event['arity'])
    elif event['kind'] == 'instance':
        f, args = event['form'], event['args']
        if not 0 <= f < len(out['forms']):
            return None
        if len(args) != out['forms'][f] or any(not 0 <= x < out['data'] for x in args):
            return None
        instance = [f, args]
        if instance not in out['instances']:
            out['instances'].append(instance)
    else:
        raise ValueError('Unknown event')
    return out


def separated(state):
    # Independently enumerate contexts, including multiple holes. Compare sets
    # of contexts that accept each datum, rather than calling Omega's model.
    profiles = [set() for _ in range(state['data'])]
    instances = {(f, tuple(args)) for f, args in state['instances']}
    for f, arity in enumerate(state['forms']):
        for context in product(range(-1, state['data']), repeat=arity):
            if -1 not in context:
                continue
            for datum, profile in enumerate(profiles):
                args = tuple(datum if x == -1 else x for x in context)
                if (f, args) in instances:
                    profile.add((f, context))
    return [[x, y] for x in range(state['data']) for y in range(x + 1, state['data'])
            if profiles[x] != profiles[y]]


def verify_case(row):
    current = deepcopy(row['initial'])
    attempts = []
    for event in row['events']:
        result = step(current, event)
        attempts.append({'event': event, 'before': current, 'result': result,
                         'accepted': result is not None})
        current = result
        if current is None:
            break
    require(row['attempts'] == attempts, 'attempt trace mismatch')
    for field in ('result', 'wdp_replay', 'rooted_replay'):
        require(row[field] == current, field + ' mismatch')
    require(row['proposed_item_cost'] == len(row['events']), 'item cost mismatch')
    require(row['proposed_arity_cost'] == sum(e.get('arity', 0) for e in row['events']),
            'arity cost mismatch')
    require(row['separated'] == (None if current is None else separated(current)),
            'separation report mismatch')


def verify_walk(walk):
    require(len(walk['bounded']) == 365, 'bounded population size')
    require(len(walk['fixtures']) == 13, 'fixture population size')
    # Guard the declared population, not merely the answers in producer rows.
    alphabet = [{'kind': 'datum'}, {'kind': 'form', 'arity': 0},
                {'kind': 'form', 'arity': 1}, {'kind': 'form', 'arity': 2},
                {'kind': 'instance', 'form': 0, 'args': []},
                {'kind': 'instance', 'form': 0, 'args': [0]},
                {'kind': 'instance', 'form': 0, 'args': [2]},
                {'kind': 'instance', 'form': 1, 'args': [0]}]
    def state(n, forms, instances, requirements):
        return dict(data=n, forms=forms, instances=instances, requirements=requirements)
    starts = [state(0, [], [], []), state(2, [], [], [[0, 1]]),
              state(3, [], [], [[1, 2]]), state(2, [1], [[0, [0]]], [[0, 1]]),
              state(3, [1], [[0, [0]]], [[0, 1]])]
    words = [[]] + [[e] for e in alphabet] + [[a, b] for a in alphabet for b in alphabet]
    expected = [(s, es) for s in starts for es in words]
    require([(r['initial'], r['events']) for r in walk['bounded']] == expected,
            'bounded population coverage')
    for row in walk['bounded'] + walk['fixtures']:
        verify_case(row)
    require([p['reading'] for p in walk['prefixes']] == ['L', 'F'], 'reading coverage')
    for p, count, pair in zip(walk['prefixes'], [2, 3], [[0, 1], [1, 2]]):
        require(p['literal_supply'] == '<>', 'root token changed')
        require(p['after_supply'] == starts[0], 'supply admitted data')
        trace = p['data_trace']
        require(trace['initial'] == starts[0], 'nonempty root')
        require(trace['events'] == [{'kind': 'datum'}] * count, 'datum prefix changed')
        verify_case(trace)
        require(trace['result'] == state(count, [], [], []), 'datum initialization')
        require(p['supplied_requirement'] == pair, 'requirement changed')
        require(p['requirement_is_Item4_event'] is False, 'requirement smuggled into Item4')
        require(p['after_requirement'] == state(count, [], [], [pair]), 'demand initialization')
    fixtures = {r['name']: r for r in walk['fixtures']}
    require(len(fixtures) == 13, 'duplicate fixture names')
    for name, pair in [('L-left', [0, 1]), ('L-right', [0, 1]),
                       ('F-left', [1, 2]), ('F-right', [1, 2])]:
        row = fixtures[name]
        require(pair in row['separated'], 'unary response did not separate')
        require((row['proposed_item_cost'], row['proposed_arity_cost']) == (2, 1), 'unary price')
    for name in ('reversed', 'zero-arity', 'wrong-arity', 'outside-carrier', 'undeclared-form'):
        require(fixtures[name]['result'] is None, 'expected refusal: ' + name)
    require(fixtures['duplicate']['result'] == fixtures['L-left']['result'], 'duplicate endpoint')
    require(fixtures['duplicate']['proposed_item_cost'] == 3, 'duplicate occurrence lost')
    require(fixtures['accepted-idle']['result'] == fixtures['accepted-idle']['initial'], 'idle accepted')
    require([0, 2] not in fixtures['recollapse']['separated'], 'recollapse control lost')
    require(separated(fixtures['recollapse']['initial']) == [[0, 1], [0, 2]], 'control initial')
    require(fixtures['fresh-preserves']['separated'] == [[0, 1], [0, 2], [1, 2]], 'fresh preservation')
    return {'bounded_cases': 365, 'fixtures': 13, 'reading_prefixes': 2,
            'accepted_bounded': sum(r['result'] is not None for r in walk['bounded']),
            'refused_bounded': sum(r['result'] is None for r in walk['bounded'])}


def mutation_controls(walk):
    rows = {r['name']: r for r in walk['fixtures']}
    mutants = {}
    r = deepcopy(rows['L-left']); r['events'].reverse(); mutants['event-order'] = r
    r = deepcopy(rows['L-left']); r['events'][1]['args'] = [2]; mutants['argument'] = r
    r = deepcopy(rows['outside-carrier']); r['result'] = r['initial']; mutants['refusal-as-idle'] = r
    r = deepcopy(rows['fresh-preserves']); r['separated'] = [[0, 1]]; mutants['retained-report'] = r
    r = deepcopy(rows['duplicate']); r['proposed_item_cost'] = 2; mutants['occurrence-cost'] = r
    results = {}
    for name, mutant in mutants.items():
        try:
            verify_case(mutant)
        except ValueError as error:
            results[name] = {'rejected': True, 'reason': str(error)}
        else:
            raise ValueError('Surviving mutation: ' + name)
    return results
