#! /bin/bash
echo "Einnahme eingeben: "
read Einnahme
ok=h
until [ $ok = "n" ]
	do 	
		Einnahmen=$Einnahme
		echo "weitere Einnahmen angeben? [y/n]"
		echo "Einnahmen = "$Einnahmen
		read -n 1 -s ok
		if [ $ok = "y" ]  		
		then 	echo "Einnahme eingeben:"		
			read EinnahmeB
			Einnahme='echo $Einnahmen + $EinnahmeB | bc'
			echo "Einnahmen = "$Einnahme
		else
		echo ""
		fi
	done
echo "Ausgabe eingeben: "
read Ausgabe
Rest="echo $Einnahmen - $Ausgabe | bc"
echo "Rest = "$Rest
until (( $Rest = 0.00 ))
do 
		Ausgaben=$Ausgabe
		echo "Ausgabe eingeben:"		
		read AusgabeB
		Ausgabe='echo $Ausgaben + $AusgabeB | bc'
		Rest='echo $Einnahmen - $Ausgabe | bc'
		echo "Rest = "$Rest
done

echo "done"
#echo "Einnahme eingeben: "
#num=1
#until test $num -eq 10
#do
#    num=$(( $num + 1 ))
#    echo $num
#done
