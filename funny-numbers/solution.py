def int_to_funnynumber(target):
	if target > 0:	
		prev_current, current, i = 0, 0, 0
		
		while(current < target):
		    i+=1
		    prev_current = current
		    current = 2 ** i + prev_current
		    
		number = bin(target - 1 - prev_current)[2:]
		bin_str = '5'*(i - len(number)) + number
		
		return int(bin_str.replace('0', '5').replace('1','6'))
    
if __name__ == '__main__':
    print(int_to_funnynumber(int(input(""))))

