

library(geobr)
library(dplyr)
library(sf)
library(stringi)
library(leaflet)
library(leaflet.extras)
library(htmltools)
library(htmlwidgets)
library(readxl)
library(colorspace)

UF <- "MG"
ARQUIVO_DADOS <- "data/dados_regionalizacao.xlsx"
NOME_REGIONALIZACAO_1 <- "Regionalização Nível 1"
NOME_REGIONALIZACAO_2 <- "Regionalização Nível 2"
ARQUIVO_SAIDA <- "output/mapa_interativo.html"

padroniza <- function(x){
  x |>
    stri_trans_general("Latin-ASCII") |>
    tolower() |>
    trimws()
}

dados <- read_xlsx(ARQUIVO_DADOS) |>
  mutate(code_muni = as.numeric(code_muni))

municipios <- read_municipality(
  code_muni = UF,
  year = 2020
) |>
  st_transform(4326)

mapa_municipios <- municipios |>
  left_join(dados, by = "code_muni") |>
  mutate(
    tooltip = lapply(
      paste0(
        "<strong>Município:</strong> ", name_muni, "<br/>",
        "<strong>", NOME_REGIONALIZACAO_1, ":</strong> ",
        regionalizacao_1, "<br/>",
        "<strong>", NOME_REGIONALIZACAO_2, ":</strong> ",
        regionalizacao_2
      ),
      HTML
    )
  )

regionalizacao_1 <- mapa_municipios |>
  group_by(regionalizacao_1) |>
  summarise()

cores_reg1 <- qualitative_hcl(
  n = nrow(regionalizacao_1),
  palette = "Dark 3"
)

regionalizacao_1$cor <- cores_reg1

pal_reg1 <- colorFactor(
  palette = cores_reg1,
  domain = regionalizacao_1$regionalizacao_1
)

regionalizacao_2 <- mapa_municipios |>
  group_by(regionalizacao_2) |>
  summarise()

cores_reg2 <- qualitative_hcl(
  n = nrow(regionalizacao_2),
  h = c(0, 360),
  c = 70,
  l = 65
)

regionalizacao_2$cor <- cores_reg2

mapa <- leaflet(options = leafletOptions(zoomSnap = 0.25)) |>
  addProviderTiles("CartoDB.Positron") |>
  addPolygons(
    data = regionalizacao_1,
    fillColor = ~cor,
    fillOpacity = 0.55,
    color = "#444444",
    weight = 1.5,
    opacity = 0.7,
    group = NOME_REGIONALIZACAO_1
  ) |>
  addPolygons(
    data = regionalizacao_2,
    fillColor = ~cor,
    fillOpacity = 0.35,
    color = "#666666",
    weight = 1,
    opacity = 0.5,
    group = NOME_REGIONALIZACAO_2
  ) |>
  addPolygons(
    data = mapa_municipios,
    fill = TRUE,
    fillOpacity = 0,
    color = "#666666",
    weight = 0.5,
    opacity = 0.5,
    layerId = ~name_muni,
    label = ~tooltip,
    highlightOptions = highlightOptions(
      weight = 2,
      color = "#333333",
      fillOpacity = 0.15,
      bringToFront = TRUE
    ),
    group = "Municípios"
  ) |>
  addSearchFeatures(
    targetGroups = "Municípios",
    options = searchFeaturesOptions(
      zoom = 8,
      openPopup = FALSE,
      firstTipSubmit = TRUE,
      autoCollapse = TRUE,
      hideMarkerOnCollapse = TRUE
    )
  ) |>
  addLayersControl(
    overlayGroups = c(
      NOME_REGIONALIZACAO_1,
      NOME_REGIONALIZACAO_2,
      "Municípios"
    ),
    options = layersControlOptions(collapsed = FALSE)
  )

saveWidget(mapa, file = ARQUIVO_SAIDA, selfcontained = TRUE)
mapa
