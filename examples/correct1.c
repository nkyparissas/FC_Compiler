#include "fclib.h"

 int i , k ;
 static int cube (  int i  ) {
return i * i * i;
}
   void add (  int n ,  int k  ) {
 int j ;
 ;
j  = n + cube ( k );
writeInteger ( j );
}
  int main (  ) {
k  = readInteger ( );
i  = readInteger ( );
add ( k, i );
for ( ; ;  ) {
writeString ( "\nPrinting Forever!\n" );
break;
}
 writeString ( "I was kidding!\n" );
return 0;
}