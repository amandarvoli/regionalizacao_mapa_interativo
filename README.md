# regionalizacao_mapa_interativo
Mapa interativo desenvolvido em R e Leaflet para visualização de municípios e diferentes regionalizações territoriais.  O projeto foi criado para facilitar a exploração de recortes territoriais de forma dinâmica, permitindo a comparação entre múltiplas regionalizações, busca por municípios e navegação interativa em mapas.
## Funcionalidades

* Visualização de municípios em mapa interativo
* Suporte a múltiplas regionalizações territoriais
* Busca por município
* Zoom automático ao selecionar um município
* Controle de camadas
* Legendas automáticas
* Exportação para HTML

## Estrutura da Planilha

|code\_muni|regionalizacao\_1|regionalizacao\_2|
|-|-|-|

## Instalação

```r
install.packages(c(
  "geobr","dplyr","sf","stringi","leaflet",
  "leaflet.extras","htmltools","htmlwidgets",
  "readxl","colorspace"
))
```

## Configuração

Edite no início do script:

```r
UF <- "MG"
ARQUIVO\_DADOS <- "data/dados\_regionalizacao.xlsx"
NOME\_REGIONALIZACAO\_1 <- "Regionalização Nível 1"
NOME\_REGIONALIZACAO\_2 <- "Regionalização Nível 2"
```
