#include "fclib.h"

 bool prime (  int n  ) {
 int i ;
  bool isPrime , result ;
 if ( n < 0 ) result  = prime ( -n );
 else if ( n < 2 ) result  = false;
 else if ( n == 2 ) result  = true;
 else if ( n % 2 == 0 ) result  = false;
 else {
i  = 3;
isPrime  = true;
while ( isPrime && i <= n / 2 ) {
isPrime  = (n % i != 0);
i  = i + 2;
}
 result  = isPrime;
}
 return result;
}
   int main (  ) {
 int limit , number , counter  = 0;
 limit  = readInteger ( );
for ( number  = 1; number <= 3; number  = number + 1 ) if ( limit >= number ) {
counter  = counter + 1;
writeInteger ( number );
}
 number  = 6;
while ( number <= limit ) {
if ( prime ( number - 1 ) ) {
counter  = counter + 1;
writeInteger ( number - 1 );
}
 if ( (number != limit) && prime ( number + 1 ) ) {
counter  = counter + 1;
writeInteger ( number + 1 );
}
 number  = number + 6;
}
 writeInteger ( counter );
return 0;
}