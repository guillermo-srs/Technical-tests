import numpy as np
num_const = np.array(['1','2','3','x','*'])

def is_valid_id(ids, open_spaces):
    if min(len(ids),len(open_spaces)) > 0:
        aux_spaces = np.pad(open_spaces, 1)
        return ids[aux_spaces[ids] == 0]
    return []

def line_to_prob(probs, depth, prev_open_spaces, ret_probs):
    if depth != 0:
        new_probs = probs.copy()
        line = np.array(list(input("")))
        open_spaces = np.zeros(len(line))
        open_spaces[line == 'x'] = 1
        value = 0

        for idx in np.where(line.reshape(-1, 1) == num_const)[0]:
            if line[idx] == '*':
                new_probs[idx+1] = 1
            elif line[idx] == 'x':
                ids = is_valid_id(
                    np.array([idx, idx+2]),
                    np.logical_or(
                        prev_open_spaces,
                        open_spaces))
                for elem in ids:
                    new_probs[elem] += int(2/len(ids))
                new_probs[idx+1] = 0
            else:
                if any(new_probs != 0):
                    value = new_probs[idx+1]/np.sum(new_probs)
                ret_probs[int(line[idx]) - 1] = value

        return line_to_prob(new_probs,
                            depth-1,
                            open_spaces,
                            ret_probs)
    return ret_probs

def init_game():
    depth, cols = input("").split(" ")
    for elem in line_to_prob(
            np.zeros(int(cols)+2),
            int(depth),
            np.zeros(int(cols)),
            np.zeros(3)):
        print(elem)


if __name__ == '__main__':
    init_game()
