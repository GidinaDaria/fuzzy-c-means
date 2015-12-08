# fuzzy-c-means
Lab1 FProg

## Author
```bash
Гайдина Дарья, группа 151003
```

## Параметры
```bash

Usage:[FILE] 
      [-v|--output FILE] 
      [-c|--cluster INT]
      [-p|--precision DOUBLE] 
      [-d|--delimiter CHAR] 
      [-u|--ignorefr]
      [-i|--ignorefc]
      [-o|--ignorelc] 
      [-m|--metric NAME]
      [-n|--initialMatrix NAME]

  Available options:
  -h,--help                Show this help text
  FILE                     File with data
  -v,--output FILE         Output file
  -c,--cluster INT         Set count of clusters
  -p,--precision DOUBLE    Set precision of FCM-algorithm
  -d,--delimiter CHAR      Det delimiter for CSV-file parsing
  -u,--ignorefr            To ignore the first row use this flag. Default is not ignore
  -i,--ignorefc            To ignore the first column use this flag. Default is not ignore
  -o,--ignorelc            To not ignore the last column use this flag. Default is ignore
  -m,--metric NAME         Distance metric Hamming, Evklid (default Evklid)
  -n,--initialMatrix NAME  Supply Matrix: RandomMatrix, RandomCenter(default RandomMatrix)

```

## Installation
```bash
$ git clone https://github.com/GidinaDaria/fuzzy-c-means.git
$ cabal update
$ cabal install csv-conduit
$ cabal install HUnit
$ cabal install optparse-applicative
$ cabal configure
$ cabal build
```
#### How to use
```bash
$ dist\build\Lab1\Lab1.exe
```

### Result example
```
[7.6485058186592e-2,0.9235149418134079]
[0.17894879333577735,0.8210512066642227]
[0.10786376640314739,0.8921362335968526]
[0.1533989430713483,0.8466010569286517]
[1.9650629525255647e-2,0.9803493704747442
[9.956356626655492e-2,0.9004364337334451]
[0.15862315777686112,0.8413768422231389]
[0.7877658775171691,0.21223412248283094]
[0.8849781498032765,0.1150218501967234]
[0.8265922836331864,0.1734077163668136]
[0.8839014472426221,0.1160985527573779]
[0.9746295257308604,2.537047426913951e-2]
[0.9232542418777558,7.674575812224417e-2]
[0.8052391205264456,0.19476087947355433]
[0.8344011310653898,0.16559886893461018]
```

#### Test usage
```bash
$ dist\build\Tests\Tests.exe
```


