#Este é um código para realizar permutação da função de rarefação (rrarefy) do pacote VEGAN (https://cran.r-project.org/web/packages/vegan/index.html)
#Criado por Edson Delatorre

library("vegan")

#Importa data frame com os dados da diversidade da comunidade (arquivo tabular)
Comun1_db <- read.delim2("~\\Path\\to\\file.txt", header = TRUE, sep = "\t", dec = ",", fill = TRUE)

#Tamanho da amostra
sample = 10           
#Prefixo dos arquivos de output da sub-amostragem = data.frame
prefix = "Comun1_db"    
#Número de replicatas
rep = 100              

#Replicatas
for(i in 1:rep)       
{
name <- paste(prefix, "_", i, "_r", sep = "")
#Gera n = "rep" tabelas rarefeitas randomicas de tamanho = "sample" (função rrarefy() Vegan) 
assign(name, rrarefy(get(prefix), sample))																		                
name2 <- paste(name, "_SH", sep = "")
#Cálculo do índice de Shannon para tabela rarefeita (função diversity() Vegan)
assign(name2, diversity(get(name), index = "shannon", MARGIN = 1, base = exp (1)))			
}

#Gera a lista com todas as tabelas de índices de Shannon (mudar de acordo com o prefixo estipulado)
SH_list = lapply(ls(pattern = "Comun1_db_[0-9]_r_SH"), get)														      

#Cálculo da média dos índices de Shannon
Reduce(`+`, SH_list) / length(SH_list) -> Comun1_db_r_SH_mean													      

#Cálculo dos índices de Shannon normalizados (SHn) pelo tamanho amostral
Comun1_db_r_SH_mean / log(sample, base = exp(1)) -> Comun1_db_r_SH_mean_norm

#Salva o resultado em um arquivo CSV
write.table(cbind(Comun1_db_r_SH_mean, Comun1_db_r_SH_mean_norm), file = "~\\Path\\to\\file.txt") 
