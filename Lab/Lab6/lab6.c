#include <cstdint>
#include <iostream>
#include <fstream>
//#define LENGTH 3
#define MAXLEN 100

int16_t lab1(int16_t a, int16_t b) {
	int16_t outcome  = 0;
	int16_t operater = 0x0001;
	if(b <= 0)
	{
		return -1;  //输入不合法 
	}
	else
	{   int i;
		for(i = 1; i <= b; i++)
		{
			if( (a & operater) == operater)  outcome++;
			operater = operater + operater;
		}
		return outcome;
	}
}

int16_t modulo(int16_t x, int16_t y){
	// return the value of  x % y (取模函数，用于lab2) 
	while(x > 0){
		x = x - y;
	}
	x = x + y;
	return x; 
}

int16_t lab2(int16_t p, int16_t q, int16_t n) {
	//递推 
	int16_t  result, tmp1, tmp2; 
	tmp1 = tmp2 = 1;
    for(int i = n-1 ; i>0 ; --i){
    	result =  modulo(tmp1, p) + modulo(tmp2, q);
    	tmp1 = tmp2;
    	tmp2 = result;
	}
	return result;
}


int16_t lab3(int16_t n, char s[]) {
    int16_t max = 0, tmp = 1;
    char former = 0, latter= 1; 
    n--;
    while(n)
    {
    	if(s[former] == s[latter]) tmp++;
    	else
		{
		    if(tmp > max) max = tmp;
		    tmp = 1;
		}
		former++;
        latter++;
        n--;
	}
	if(tmp > max) max = tmp; //对结尾做处理，因为如果结尾的子串最长，在上面的循环里tmp是不会替换max的。 
	return max;
}


void lab4(int16_t score[], int16_t *a, int16_t *b) {
	int i,j;
	int16_t tmp, minpos, min, ranka=0, rankb=0;
	//sort 
    for(i = 0; i < 16; i++)
    {   
        min = 999;
        for(j = i; j < 16; j++)
    	{
		    if(score[j] < min)  
			{
			    min = score[j];
			    minpos = j;
		    }
		    
		}   
		tmp = score[i];
        score[i] = score[minpos];
	    score[minpos] = tmp;	
	}
	//count
    for(i = 15; i >= 12 ; i--)
    {
    	if(score[i] >= 85) ranka++;
    	else if(score[i] >= 75) rankb++;
	}
	for(i = 11; i >= 8 ; i--)
	{
		if(score[i] >= 75) rankb++;
	}
	
	*a = ranka;
	*b = rankb;
}

int main() {
std::fstream file;
file.open("test.txt", std::ios::in);

// lab1 
int16_t a = 0, b = 0;
for (int i = 0; i < LENGTH; ++i) {
file >> a >> b;
std::cout << lab1(a, b) << std::endl;
}

// lab2
int16_t p = 0, q = 0, n = 0;
for (int i = 0; i < LENGTH; ++i) {
file >> p >> q >> n;
std::cout << lab2(p, q, n) << std::endl;
}

// lab3
char s[MAXLEN];
for (int i = 0; i < LENGTH; ++i) {
file >> n >> s;
std::cout << lab3(n, s) << std::endl;
}


// lab4
int16_t score[16];
for (int i = 0; i < LENGTH; ++i) {
for (int j = 0; j < 16; ++j) {
file >> score[j];
}
lab4(score, &a, &b);
for (int j = 0; j < 16; ++j) {
std::cout << score[j] << " ";
}
std::cout << std::endl << a << " " << b << std::endl;
}

file.close();
return 0;
}
