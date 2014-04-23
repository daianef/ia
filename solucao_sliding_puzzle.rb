$: << File.expand_path(File.dirname(__FILE__) + '/lib')

require 'parser_cli'
require 'puzzle'
require 'cromossomo'
require 'populacao'

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

# Faz o parser das opcoes da linha de comando
cli = ParserCLI.new

# Interpreta o jogo do usuario
sp = SlidingPuzzle.new(cli.arquivo)

puts "#"*10 + " JOGO DO USUARIO " + "#"*10
sp.jogo.each do |linha|
  puts linha.inspect
end
puts "#"*37 + "\n\n"

# Seta a semente do gerador de numeros aleatorios.
# Se omitido o parametro, sera' usada uma combinacao da
# data, ID do processo e numero de sequencia.
#srand()

##### PRIMEIRA POPULACAO #####
populacao_atual = Populacao.new(cli)
# Gerar cromossomos para a primeira populacao
1.upto cli.tamanho_da_populacao do |i|
  individuo = Cromossomo.new(cli.tamanho_do_cromossomo, sp.jogo, sp.estado_esperado)
  individuo.alterar_probabilidade_de_mutacao(cli.probabilidade_de_mutacao)
  individuo.gerar_novo()
  populacao_atual.adicionar_novo_cromossomo(individuo)
end

##### GERACAO DE POPULACOES #####
1.upto cli.numero_de_geracoes do |i|
  # Imprime maior fitness da populacao atual
  puts "#{i} #{populacao_atual.to_s}"

  # Guarda populacao passada
  populacao_passada = populacao_atual.dup
  # Inicia nova populacao que sera' preenchida com cromossomos filhos da populacao passada
  populacao_atual = Populacao.new(cli)
  # Escolher pais e gerar filhos
  pais = populacao_passada.escolher_pais()
  pais.each do |pai1, pai2|
    # Novo cromossomo
    individuo = Cromossomo.new(cli.tamanho_do_cromossomo, sp.jogo, sp.estado_esperado)
    individuo.alterar_probabilidade_de_mutacao(cli.probabilidade_de_mutacao)
    # Cruzamento entre pais
    individuo.crossover(pai1, pai2)
    # Testa e realiza a mutacao, se for o caso
    individuo.mutacao()
    # Alimenta a populacao
    populacao_atual.adicionar_novo_cromossomo(individuo)

    # Novo cromossomo
    individuo = Cromossomo.new(cli.tamanho_do_cromossomo, sp.jogo, sp.estado_esperado)
    individuo.alterar_probabilidade_de_mutacao(cli.probabilidade_de_mutacao)
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
    melhor_pai = populacao_passada.maior_fitness_absoluto()
    # Aplica o elitismo, no qual o cromossomo de pior fitness da populacao atual
    #  e' substituido pelo de melhor da populacao passada
    populacao_atual.elitismo(melhor_pai)
  end
end

