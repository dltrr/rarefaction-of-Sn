#Este é um código para realizar permutação da função de rarefação (rrarefy) do pacote VEGAN
#Criado por Edson Delatorre

library("vegan")

#Importa data frame com os dados das especies da comunidade
SH_db <- as.data.frame(read.csv("~/Path/to/file.csv", header = TRUE, sep = ",", dec = ",", fill = TRUE))	

#Tamanho da amostra
sample = 10           
#Prefixo dos arquivos de output da sub-amostragem
prefix = "Comun1_db_r"    
#Número de replicatas
rep = 100              

#Replicatas
for(i in 1:rep)       
{
name <- paste(prefix, i, sep = "")
#Gera n = "rep" tabelas rarefeitas randomicas de tamanho = "sample" (função rrarefy() Vegan) 
assign(name, rrarefy(SH_db, sample))																		                
name2 <- paste(prefix, "_SH", i, sep = "")
#Cálculo do índice de Shannon para tabela rarefeita
assign(name2, diversity(get(name), index = "shannon", MARGIN = 1, base = exp (1)))			
}

#Gera a lista com todas as tabelas de índices de Shannon
SH_list = lapply(ls(pattern = "SH_db_r_SH[0-9]"), get)														      

#Cálculo da média dos índices de Shannon
Reduce(`+`, SH_list) / length(SH_list) -> Comun1_db_r_SH_mean													      

#Cálculo dos índices de Shannon normalizados (SHn)
Comun1_db_r_SH_mean / log(sample, base = exp(1)) -> Comun1_db_r_SH_mean_norm

#Salva o resultado em um arquivo CSV
write.csv(cbind(Comun1_db_r_SH_mean, Comun1_db_r_SH_mean_norm), file = "~\\Path\\to\\file.csv") 
