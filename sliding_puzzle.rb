#####################################################################
# 
# INTELIGENCIA ARTIFICIAL APLICADA
#
# TRABALHO 1: Resolvendo o Sliding Puzzle com algoritmos geneticos
#
# Alunas: Daiane Fraga, Marcia Federizzi
#
# 2014/1
#
#####################################################################

### Constantes ###
TAMANHO_CROMOSSOMO = 8
TAMANHO_POPULACAO = 100
NUMERO_DE_GERACOES = 100
NRO_SORTEIO = 3
PROB_MUTACAO = 0.1

############## BUSCA PELA SOLUCAO DO SLIDING PUZZLE ################

# Criar uma nova populacao
populacao_atual = Populacao.new
# Gerar cromossomos
1.upto TAMANHO_POPULACAO do |i|
  individuo = Cromossomo.new
  individuo.gerar_novo()
  populacao_atual.adicionar_novo_cromossomo(individuo)
end

# Seta a semente do gerador de numeros aleatorios.
# Se omitido o parametro, sera' usada uma combinacao da
# data, ID do processo e numero de sequencia.
srand()

##### GERACAO DE POPULACOES #####
1.upto NUMERO_DE_GERACOES do |i|
  # Imprime maior fitness da populacao atual
  puts "#{i} #{populacao_atual.to_s}"

  # Guarda populacao passada
  populacao_passada = populacao_atual.dup
  # Inicia nova populacao que sera' preenchida com cromossomos
  # filhos da populacao passada
  populacao_atual = Populacao.new

  # Escolher pais e gerar filhos
  pais = populacao_passada.escolher_pais()
  pais.each do |pai1, pai2|
    # Novo cromossomo
    individuo = Cromossomo.new
    # Cruzamento entre pais
    individuo.crossover(pai1.heranca_1, pai2.heranca_2)
    # Testa e realiza a mutacao, se for o caso
    individuo.mutacao()
    # Alimenta a populacao
    populacao_atual.adicionar_novo_cromossomo(individuo)

    # Novo cromossomo
    individuo = Cromossomo.new
    # Cruzamento entre pais (trocando herancas)
    individuo.crossover(pai2.heranca_1, pai1.heranca_2)
    # Testa e realiza a mutacao, se for o caso
    individuo.mutacao()
    # Alimenta a populacao
    populacao_atual.adicionar_novo_cromossomo(individuo)
  end

  melhor_pai = populacao_passada.maior_fitness_absoluto()
  populacao_atual.elitismo(melhor_pai)
end

#################################################################
