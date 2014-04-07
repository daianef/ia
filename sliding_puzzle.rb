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

### Classes ###

#
# Um cromossomo contem um sequencia de passos do espaco vazio.
# Assim, cada gene e' um movimento.
#
class Cromossomo
  # Permissao de leitura para o atributo fitness
  attr_reader :fitness

  #
  # Construtor da classe.
  # Inicia o cromossomo com atributos de valor generico.
  #
  # @genes: codigo genetico (array)
  # @fitness: valor resultante da funcao de fitness (fixnum)
  #
  def initialize
    @genes = []
    @fitness = -1
  end

  #
  # Exibicao do objeto como string.
  #
  def to_s
    s = ""
    @genes.each do |c|
      s += "#{c} "
    end
#    s += "\n"

    s
  end

  #
  # Gera genes aleatorios. Corresponde ao nascimento do cromossomo na 
  # primeira populacao. 
  #
  def gerar_novo
    @genes = []
    
	1.upto TAMANHO_CROMOSSOMO do |i|
	  passo = rand(4)
	
	# Considerar deficiencias?
    #  while !passo_valido?(passo)
    #    passo = rand(4)
    #  end 
	  
	  @genes[i-1] = rand(2)
    end
	
    calcular_fitness()
  end

  #
  # Une dois codigos geneticos previamente fornecidos, atualizando o
  # valor do fitness.
  # Quem chama o metodo e' que define o criterio de cruzamento.
  #
  def crossover(genes1, genes2)
    @genes = genes1 + genes2
    calcular_fitness()
  end

  #
  # Processo de mutacao e' probabilistico. Posicao de mutacao e'
  # aleatoria se existe probabilidade de mutacao.
  #
  def mutacao
    raise "O cromossomo deve possuir genes." if @genes.empty?

    if deve_mutar?
      pos = sortear_posicao()
      @genes[pos] = 1 - @genes[pos]
    end
  end

  #
  # Retorna primeira metade dos genes.
  #
  def heranca_1
    @genes[0..(TAMANHO_CROMOSSOMO/2)-1]
  end

  #
  # Retorna segunda metade dos genes.
  #
  def heranca_2
    @genes[TAMANHO_CROMOSSOMO/2..TAMANHO_CROMOSSOMO-1]
  end

  ############ Metodos privados ############
  private

  #
  # Calcula valor numerico da funcao fitness
  # do cromossomo.
  #
  def calcular_fitness
    @fitness = 0
    # TODO
  end

  #
  # Sorteia uma posicao entre o codigo genetico.
  #
  def sortear_posicao
    rand(TAMANHO_CROMOSSOMO-1)
  end

  #
  # Calcula a probabilidade de mutacao e
  # verifica se a mutacao e' desejada.
  #
  def deve_mutar?
	num = (rand(1000)+1).to_f/1000.to_f
	num <= PROB_MUTACAO  
  end
end



#
# Classe para representar uma populacao de cromossomos.
#
class Populacao
  #
  # Construtor da classe. Inicia com populacao vazia.
  #
  def initialize
    @cromossomos = []
  end

  #
  # Exibicao do objeto como string.
  #
  def to_s
    str = "#{maior_fitness(@cromossomos).fitness} "
  #  @cromossomos.each do |i|
  #    str += i.to_s + "\n"
  #  end
  #  str + "\n"
  end

  #
  # Acrescenta a populacao um novo cromossomo.
  #
  def adicionar_novo_cromossomo(cromo)
    @cromossomos << cromo
  end

  #
  # Escolher pares de pais aptos para reproducao.
  # Numero de pais e' igual a metade do numero de
  # cromossomos.
  #
  def escolher_pais
    pais = []
    1.upto @cromossomos.size/2 do |i|
      pais[i-1] = []
      pais[i-1][0] = maior_fitness(sortear_cromossomos())
      pais[i-1][1] = maior_fitness(sortear_cromossomos())
    end

    pais
  end

  #
  # Retorna o cromossomo de maior fitness dentro da populacao.
  #
  def maior_fitness_absoluto
    maior_fitness(@cromossomos)
  end

  #
  # Aplica o elitismo na populacao. Recebe o melhor pai (maior fitness) da 
  # populacao passada e o coloca no lugar do cromossomo de menor fitness da
  # populacao atual.
  #
  def elitismo(melhor_pai)
    index = @cromossomos.index(menor_fitness_absoluto)
    @cromossomos[index] = melhor_pai
  end

  ############ Metodos privados ############
  private

  #
  # Retorna o cromossomo de maior fitness dentro da lista fornecida.
  #
  def maior_fitness(elementos)
    maior = elementos.first
    elementos.each do |e|
      maior = e if e.fitness > maior.fitness
    end

    maior
  end

  #
  # Sorteia 3 cromossomos.
  #
  def sortear_cromossomos
    ids = []
    1.upto NRO_SORTEIO do |i|
      ids[i-1] = rand(@cromossomos.size)
    end

    [@cromossomos[ids[0]], @cromossomos[ids[1]], @cromossomos[ids[2]]]
  end
  
  #
  # Retorna o cromossomo de menor fitness dentro da populacao.
  #
  def menor_fitness_absoluto
    menor = @cromossomos.first
    @cromossomos.each do |e|
      menor = e if e.fitness < menor.fitness
    end

    menor
  end
end


class Peca
  def initialize
    @valor =
    @posicao_atual = 
    @posicao_correta =
  end
  
  def <=>
  end
  
  def ==
  end
  
  def to_s
  end
end

#
# Classe que representa um jogo Sliding Puzzle NxN.
#
class SlidingPuzzle
  def initialize()
    @linhas = [] 
    @pecas_ordenadas = []
  end
  
  

end



############## BUSCA PELA SOLUCAO DO SLIDING PUZZLE ################

# Configuracao do jogo
# TODO: tornar parametrizavel e de qualquer tamanho
jogo = [ 
  [3, 2, 1],
  [6, 5, 4],
  [7, 8, nil]
]

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
