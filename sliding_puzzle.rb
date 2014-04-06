
TAMANHO_CROMOSSOMO = 100
TAMANHO_POPULACAO = 100
NRO_SORTEIO = 3
PROB_MUTACAO = 0.1

#
# Um cromossomo contem um sequencia de passos
#
#
class Cromossomo
  # Permissao de leitura para o atributo fitness
  attr_reader :fitness

  #
  # Construtor da classe.
  # Inicia com codigo vazio e fitness
  # nao calculado (-1).
  #
  def initialize
    @codigo = []
    @fitness = -1
  end

  #
  # Exibicao do objeto como string.
  #
  def to_s
    s = ""
    @codigo.each do |c|
      s += "#{c} "
    end
#    s += "\n"

    s
  end

  #
  # Gera um novo codigo, usado quando nao existe
  # nenhuma populacao (nao ha pais). Codigo e' aleatorio.
  #
  def gerar_novo
    @codigo = []
    1.upto TAMANHO_CROMOSSOMO do |i|
      @codigo[i-1] = rand(2)
    end
    calcular_fitness()
  end

  #
  # Codigo e' resultado de uma combinacao de codigos, isto e',
  # existe um cruzamento de codigos.
  #
  def crossover(codigo1, codigo2)
    @codigo = codigo1 + codigo2
    calcular_fitness()
  end

  #
  # Processo de mutacao e' probabilistico. Posicao de mutacao e'
  # aleatoria se existe probabilidade de mutacao.
  #
  def mutacao
    raise "O cromossomo deve ter um codigo." if @codigo.empty?

    prob = probabilidade()
    if probabilidade() <= PROB_MUTACAO
      pos = sortear_posicao()
      @codigo[pos] = 1-@codigo[pos]
    end
  end

  #
  # Retorna primeiros 4 bits do codigo.
  #
  def heranca_1
    @codigo[0..(TAMANHO_CROMOSSOMO/2)-1]
  end

  #
  # Retorna ultimos 4 bits do codigo.
  #
  def heranca_2
    @codigo[TAMANHO_CROMOSSOMO/2..TAMANHO_CROMOSSOMO-1]
  end

  private

  #
  # Calcula valor numerico da funcao fitness
  # do cromossomo.
  #
  def calcular_fitness
    @fitness = 0
    @codigo.each { |c| @fitness += c }
  end

  #
  # Sorteia uma posicao do codigo.
  #
  def sortear_posicao
    rand(TAMANHO_CROMOSSOMO-1)
  end

  #
  # Calcula a probabilidade de mutacao.
  #
  def probabilidade
    (rand(1000)+1).to_f/1000.to_f
  end
end


#
# Classe para representar uma populacao de individuos. Neste caso,
# uma populacao de cromossomos.
#
class Populacao
  #
  # Construtor da classe. Inicia com populacao vazia.
  #
  def initialize
    @individuos = []
  end

  #
  # Exibicao do objeto como string e' o maior valor entre
  # as funcoes de fitness dos individuos.
  #
  def to_s
    str = "#{maior_fitness(@individuos).fitness} "
  #  @individuos.each do |i|
  #    str += i.to_s + "\n"
  #  end
  #  str + "\n"
  end

  #
  # Mata populacao (reseta variavel de individuos).
  #
  def reset
    @individuos = []
  end

  #
  # Alimenta populacao com um novo individuo.
  #
  def alimentar_populacao(individuo)
    @individuos << individuo
  end

  #
  # Escolher pares de pais aptos para reproducao
  # (numero de pais e' igual a metade do numero de
  # individuos dividido por 2).
  #
  def escolher_pais
    pais = []
    1.upto @individuos.size/2 do |i|
      pais[i-1] = []
      pais[i-1][0] = maior_fitness(sortear())
      pais[i-1][1] = maior_fitness(sortear())
    end

    pais
  end

  #
  # Sorteia 3 individuos.
  #
  def sortear
    ids = []
    1.upto NRO_SORTEIO do |i|
      ids[i-1] = rand(@individuos.size)
    end

    [@individuos[ids[0]], @individuos[ids[1]], @individuos[ids[2]]]
  end

  #
  # Retorna o cromossomo de maior fitness.
  #
  def maior_fitness(elementos)
    maior = elementos.first
    elementos.each do |e|
      maior = e if e.fitness > maior.fitness
    end

    maior
  end

  def maior_fitness_absoluto
    maior_fitness(@individuos)
  end

  def elitismo(melhor_pai)
    index = @individuos.index(menor_fitness_absoluto)
    @individuos[index] = melhor_pai
  end

  private

  def menor_fitness_absoluto
    menor = @individuos.first
    @individuos.each do |e|
      menor = e if e.fitness < menor.fitness
    end

    menor
  end
end

#################################################################

# Criar nova populacao
populacao_atual = Populacao.new
1.upto TAMANHO_POPULACAO do |i|
  individuo = Cromossomo.new
  individuo.gerar_novo()
  populacao_atual.alimentar_populacao(individuo)
end

srand(Time.new.to_i.abs)

# Ciclo de 50 geracoes
1.upto 100 do |i|
  # Imprime maior fitness da populacao atual
  puts "#{i} #{populacao_atual.to_s}"

  # Guarda populacao passada
  populacao_passada = populacao_atual.dup
  # Limpa geracao atual para guardar novos filhos
  populacao_atual.reset()

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
    populacao_atual.alimentar_populacao(individuo)

    # Novo cromossomo
    individuo = Cromossomo.new
    # Cruzamento entre pais (trocando herancas)
    individuo.crossover(pai2.heranca_1, pai1.heranca_2)
    # Testa e realiza a mutacao, se for o caso
    individuo.mutacao()
    # Alimenta a populacao
    populacao_atual.alimentar_populacao(individuo)
  end

  melhor_pai = populacao_passada.maior_fitness_absoluto()
  populacao_atual.elitismo(melhor_pai)
end

#################################################################
