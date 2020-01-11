library(dplyr)
library(xlsx)
liczSprzedanychWoj<-read.csv2("00-liczba-sprzedanych-mieszkan-wojewodztwa.csv", encoding="UTF-8")
medianaCen1m2Woj<-read.csv2("00-mediana-cen-za-1m2-wojewodztwa.csv", encoding = "UTF-8")
sredniaCenaMWoj<-read.csv2("00-srednia-cena-mieszkan-wojewodztwa.csv", encoding = "UTF-8")
sredniaCena1m2Woj<-read.csv2("00-srednia-cena-za-1m2-wojewodztwa.csv", encoding = "UTF-8")
daneWoj<-liczSprzedanychWoj
daneWoj$Jednostka.miary<-NULL
daneWoj$Atrybut<-NULL
daneWoj$Kod<-NULL
daneWoj$X<-NULL
medianaCen1m2Woj<-medianaCen1m2Woj %>% pull(Wartosc)
sredniaCenaMWoj<-sredniaCenaMWoj %>% pull(Wartosc)
sredniaCena1m2Woj<-sredniaCena1m2Woj %>% pull(Wartosc)
daneWoj$Mediana.m2<-medianaCen1m2Woj
daneWoj$Srednia.Cena.M<-sredniaCenaMWoj
daneWoj$Srednia.Cena.m2<-sredniaCena1m2Woj
daneWoj<-daneWoj %>% rename(
  Wojewodztwo=Nazwa,
  Rynek=Transakcje.rynkowe,
  Metraz=Powierzchnia.uzytkowa.lokali.mieszkalnych,
  Liczba.Sprzedanych.M=Wartosc
)
write.xlsx(daneWoj, "mieszkania-woj.xlsx")
#

