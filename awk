awk 'NR==FNR { ids[$1]; next } $3 in ids' lista.txt duzy_plik.csv > wynik.csv
