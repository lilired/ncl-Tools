procedure createDates(mes,dia) begin
suma_dias=0
dias=dia
print(dias)
meses=(/1,2,3,4,5,6,7,8,9,10,11,12/)
    do conVar3 = 0,dimsizes(meses)-1
        if mes.eq. 1 then
           suma_dias=dias
           else
           if mes.eq.2 then
              suma_dias=31+dias
           else
              if mes.eq.3 then
                 suma_dias=59+dias
              else
                 if mes.eq.4 then
                    suma_dias=90+dias
                 else
                    if mes.eq.5 then
                       suma_dias=120+dias
                    else
                       if mes.eq.6 then
                          suma_dias=151+dias
                       else
                          if mes.eq.7 then
                             suma_dias=181+dias
                          else
                             if mes.eq.8 then
                                suma_dias=311+dias
                             else
                                if mes.eq.9 then
                                   suma_dias=243+dias
                                else 
                                   if mes.eq.10 then
                                     suma_dias=273+dias
                                   else
                                     if mes.eq.11 then
                                        suma_dias=303+dias
                                     else
                                        if mes.eq.12 then
                                         suma_dias=333+dias
                                        end if
                                     end if
                                   end if
                                end if
                             end if
                          end if
                       end if
                    end if
                 end if
            end if
            end if
        end if
     end do


print("Done!")	
end
