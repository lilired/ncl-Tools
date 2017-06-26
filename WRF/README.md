Dependencies of some variables:

"preca3","preca6"
  For the precipitation of 3 or 6 hours Variables that depends: 
  Variable RAINC origin WRF
             ->PREC2
               ->PREC2B
                 ->preca3,preca6

wind 10m
  For the wind Variables that depends: 
     ->U10 Variable origin WRF
     ->V10 Variable origin WRF
       ->WS10
         ->interpolated Winds WS10


"SSTC"
  For the SSTC Variables that depends: 
   ->SST Variable origin WRF
      ->SSTC


"RH"
 For the Relative Humidity Variables that depends: 
  ->QVAPOR Variable origin WRF
    ->RH

