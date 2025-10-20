# 🌊 Análise CWT dos Parâmetros Ionosféricos - Dados OMNI

Este projeto é um script MATLAB que realiza a análise por Transformada Contínua de Wavelet (CWT) em dados ionosféricos do conjunto de dados OMNI (médias de 5 minutos). O objetivo é explorar as variações temporais e espectrais de grandezas físicas relacionadas ao vento solar e campo magnético interplanetário.

## 🛠 Tecnologias Usadas

- **MATLAB**
- Arquivo de dados tabulado `dados_Omni_Tratado.txt` (com dados OMNI pré-tratados)

![MATLAB Badge](https://img.shields.io/badge/MATLAB-R2019b-red)

## 💡 Objetivo

Aplicar a análise por CWT para identificar padrões e períodos dominantes em séries temporais de parâmetros físicos extraídos dos dados OMNI, tais como:

- Campo magnético Bz (GSM)
- Velocidade do fluxo solar
- Densidade de prótons
- Campo elétrico Ey
- Índices geomagnéticos AE e SYM-H

## 🚀 Funcionalidades

- Leitura automatizada de arquivo tabulado com dados OMNI tratados
- Conversão das colunas de data e hora em formato datetime MATLAB
- Pré-processamento para tratamento de valores ausentes (NaN)
- Aplicação da Transformada Contínua de Wavelet com filtros customizados
- Geração de gráficos espectro-temporais normalizados para cada variável
- Eixos configurados para exibir períodos em dias e datas formatadas

## 📦 Como Rodar o Projeto

### Passo 1: Preparar o arquivo de dados

Certifique-se de que o arquivo `dados_Omni_Tratado.txt` esteja na mesma pasta do script MATLAB e siga o formato tabulado com colunas:
1. DD  
2. MM  
3. YYYY  
4. HH:MM  
5. BZ, nT (GSM)  
6. Speed, km/s  
7. Proton Density, n/cc  
8. Electric field, mV/m  
9. AE-index, nT  
10. SYM/H, nT

### Passo 2: Executar o script

Abra o MATLAB, navegue até a pasta do projeto e execute o script:

```matlab
run cwt_parametros_ionosfericos.m
```

O script irá gerar gráficos interativos com a análise CWT para cada variável física.

## 🔧 Detalhes Técnicos

- A frequência de amostragem considerada é de 1 dado a cada 5 minutos (1/300 Hz).

- A extensão simétrica é aplicada para reduzir efeitos de borda na CWT.

- O espectro é normalizado para facilitar a visualização dos padrões dominantes.

- O eixo Y está em escala logarítmica, com períodos expressos em dias.

- O eixo X está formatado para mostrar datas com resolução diária e labels rotacionados para melhor leitura.

## 📂 Estrutura do Projeto

```
cwt_parametros_ionosfericos/
├── dados_Omni_Tratado.txt         # Arquivo de dados tabulados pré-tratados
├── cwt_parametros_ionosfericos.m  # Script MATLAB principal
└── README.md                      # Documentação do projeto
```

## 🤝 Agradecimentos

Este projeto facilita a análise espectral temporal de dados ionosféricos e solares, auxiliando em pesquisas na área de física espacial e geomagnetismo.

## 📜 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para mais detalhes.
