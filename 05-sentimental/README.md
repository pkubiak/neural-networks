## Sentimental Analysis ##

Projekt polegał na wyuczenie sieci neuronowej, oceniać czy zdania podane na wejściu niosą pozytywną czy negatywną treść.

Dane pochodzą ze zbioru recenzji filmów IMDB.

### Model ###

Jako model została użyta sieć RNN z komórkami LSTM. Na samym początku dane poddawane są embeddingowi
z wykorzystaniem pretrenowanego embeddingu Word2Vec, na wyjściu mamy warstwę gęstą decydującą o klasyfikacji.

### Hiperparametry ###

Wyniki treningu w sporym stoponi zależą od doboru hiperparametrów, takich jak rodzaj komórek użytych w RNN, ilości warst,
rozmiarów pamięci itp. Aby lepiej wybrać właściwe parametry, dokonałem przeszukiwania hiperparametrów, oraz ewaluacji ich
na danych testowych w celu porównania ich.

Wyniki przeszukiwania hiperparametrów dostępne są w pliku `results.tsv`.

Najlepszy osiągnięty wynik:

```
2018-02-24 23:24:32.899608      GRU     0.0     0.15    3       120     13      85.949999094    88.4614654382
```
