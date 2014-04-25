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

#
# Classe para representar uma populacao de cromossomos.
#
class Populacao
  #
  # Construtor da classe. Inicia com populacao vazia e
  #  com numero de sorteios para escolha dos pais.
  #
  def initialize(opcoes)
    @opcoes = opcoes
    @cromossomos = []
  end

  #
  # Exibicao do objeto como string.
  #
  def to_s
    cromo = melhor_fitness_absoluto()

    if @opcoes.imprimir_resultado?
      str = "#{cromo.fitness} #{cromo.resultante.inspect} "
# Descomentar para exibir fitness de todos os cromossomos
#      @cromossomos.each do |cromo1|
#        str += "#{cromo1.fitness} "
#      end
    else
      str = "#{cromo.fitness}"
    end
    
    str
  end

  #
  # Acrescenta a populacao um novo cromossomo.
  #
  def adicionar_novo_cromossomo(cromo)
    @cromossomos << cromo
  end

  #
  # Escolher pares de pais aptos para reproducao.
  # Numero de pais e' igual a metade do numero de cromossomos.
  #
  def escolher_pais
    pais = []
    1.upto @cromossomos.size/2 do |i|
      pais[i-1] = []
      pais[i-1][0] = melhor_fitness(sortear_cromossomos())
      pais[i-1][1] = melhor_fitness(sortear_cromossomos())
    end

    pais
  end

  #
  # Retorna o cromossomo de maior fitness dentro da populacao.
  #
  def melhor_fitness_absoluto
    melhor_fitness(@cromossomos)
  end

  #
  # Aplica o elitismo na populacao. Recebe o melhor pai (maior fitness) da
  #  populacao passada e o coloca no lugar do cromossomo de menor fitness da
  #  populacao atual.
  #
  def elitismo(melhor_pai)
    index = @cromossomos.index(pior_fitness_absoluto)
    @cromossomos[index] = melhor_pai
  end

  ############ Metodos privados ############
  private

  #
  # Retorna o cromossomo de melhor fitness dentro da lista fornecida.
  #
  def melhor_fitness(elementos)
    melhor = elementos.first
    elementos.each do |e|
      melhor = e if e.fitness < melhor.fitness
    end

    melhor
  end

  #
  # Sorteia n cromossomos.
  #
  def sortear_cromossomos
    ids = []
    1.upto @opcoes.numero_de_sorteios do |i|
      ids[i-1] = rand(@cromossomos.size)
    end

    sorteados = []
    ids.each do |i|
      sorteados << @cromossomos[i]
    end

    sorteados
  end

  #
  # Retorna o cromossomo com menor fitness dentro da populacao.
  #
  def pior_fitness_absoluto
    pior = @cromossomos.first
    @cromossomos.each do |e|
      pior = e if e.fitness > pior.fitness
    end

    pior
  end
end

