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

$: << File.expand_path(File.dirname(__FILE__) + '/lib')

require 'parser_cli'
require 'puzzle'
require 'cromossomo'
require 'populacao'

# Faz o parser das opcoes da linha de comando
cli = ParserCLI.new

# Interpreta o jogo do usuario
sp = SlidingPuzzle.new(cli.arquivo)
prob_mutacao = cli.probabilidade_de_mutacao

# Seta a semente do gerador de numeros aleatorios.
# Se omitido o parametro, sera' usada uma combinacao da
# data, ID do processo e numero de sequencia.
srand()

##### PRIMEIRA POPULACAO #####
populacao_atual = Populacao.new(cli)
# Gerar cromossomos para a primeira populacao
1.upto cli.tamanho_da_populacao do |i|
  individuo = Cromossomo.new(cli.tamanho_do_cromossomo, sp.jogo, sp.estado_esperado)
  individuo.alterar_probabilidade_de_mutacao(prob_mutacao)
  individuo.gerar_novo()
  populacao_atual.adicionar_novo_cromossomo(individuo)
end

##### GERACAO DE POPULACOES #####
1.upto cli.numero_de_geracoes do |i|
  # Imprime maior fitness da populacao atual
  puts "#{i} #{populacao_atual}"

  # Guarda populacao passada
  populacao_passada = populacao_atual.dup
  # Inicia nova populacao que sera' preenchida com cromossomos filhos da populacao passada
  populacao_atual = Populacao.new(cli)
  # Escolher pais e gerar filhos
  pais = populacao_passada.escolher_pais()
  pais.each do |pai1, pai2|
    # Novo cromossomo
    individuo = Cromossomo.new(cli.tamanho_do_cromossomo, sp.jogo, sp.estado_esperado)
    individuo.alterar_probabilidade_de_mutacao(prob_mutacao)
    # Cruzamento entre pais
    individuo.crossover(pai1, pai2)
    # Testa e realiza a mutacao, se for o caso
    individuo.mutacao()
    # Alimenta a populacao
    populacao_atual.adicionar_novo_cromossomo(individuo)

    # Novo cromossomo
    individuo = Cromossomo.new(cli.tamanho_do_cromossomo, sp.jogo, sp.estado_esperado)
    individuo.alterar_probabilidade_de_mutacao(prob_mutacao)
    # Cruzamento entre pais (trocando herancas)
    individuo.crossover(pai2, pai1)
    # Testa e realiza a mutacao, se for o caso
    individuo.mutacao()
    # Alimenta a populacao
    populacao_atual.adicionar_novo_cromossomo(individuo)
  end

  # Opcao de executar sem aplicar o elitismo
  unless cli.remover_elitismo?
    # Obtem o melhor pai da populacao passada
    melhor_pai = populacao_passada.melhor_fitness_absoluto()
    # Aplica o elitismo, no qual o cromossomo de pior fitness da populacao atual
    #  e' substituido pelo de melhor da populacao passada
    populacao_atual.elitismo(melhor_pai)
  end

=begin  
  # Definindo um array chamado fitnesses no inicio deste loop, e descomentando este trecho,
  # cria-se uma alteracao condicional da probabilidade de mutacao.
  
  # Se existe 100 geracoes com mesmo melhor fitness, mas que nao seja otimo, faz com que
  # aumente 5% da probabilidade de mutacao.
  if (fitnesses.uniq.size == 1 and fitnesses.size == 100) and fitnesses.last > 0
    prob_mutacao = prob_mutacao + 0.05
  end

  # Controle de acumulo das fitness.
  if fitnesses.size == 100
    fitnesses = []
  else
    fitnesses << populacao_atual.melhor_fitness
  end
=end
end

