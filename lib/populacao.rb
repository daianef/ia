#
# Classe para representar uma populacao de cromossomos.
#
class Populacao
  #
  # Construtor da classe. Inicia com populacao vazia.
  #
  def initialize(numero_de_sorteios=3)
    @numero_de_sorteios = numero_de_sorteios
    @cromossomos = []
  end

  #
  # Exibicao do objeto como string.
  #
  def to_s
=begin    str = "\n\n"
    @cromossomos.each do |cromo|
      str += "--\n"
      str += cromo.object_id.to_s + "\n"
      str += cromo.matriz_resultado.inspect + "\n"
      str += cromo.fitness.to_s + "\n"
    end

    str += "\n\nMAIOR FITNESS\n"
    cromo1 = maior_fitness_absoluto()
    str += cromo1.object_id.to_s + "\n"
    str += "#{cromo1.matriz_resultado.inspect}\n"
    str += "#{cromo1.fitness} \n"
=end

    cromo = maior_fitness_absoluto()

    "#{cromo.fitness} #{cromo.resultante.inspect} #{cromo.genes.inspect}"
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
    1.upto @numero_de_sorteios do |i|
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
