#include<stdio.h>
#include<stdint.h>
extern void dpi_test_funciton(unint8_t* arry_in);
vodi C_ref_model(uint8_t* inout arry_in ){
    int length = sizeof(arry_in) ;
    for(int i = 0; i < length; i++) {
        arry_in[i] = arry_in[i] + 1; // Example operation: increment each element by 1
    } 
    dpi_test_funciton(arry_in);
     return 0;
}
