#
# Um cromossomo contem uma sequencia de passos da peca guia (espaco vazio).
# Assim, cada gene e' um movimento.
#
class Cromossomo
  # Permissao de leitura para o atributo fitness
  attr_reader :fitness

  #
  # Construtor da classe.
  # Inicia o cromossomo com atributos de valor generico.
  #
  #
  def initialize(tamanho, atual, final)
    raise "Parametro atual deve ser Array." unless atual.is_a? Ar
    raise "Parametro final deve ser Array." unless final.is_a? Array

    @tamanho = tamanho
    @jogo_usuario = atual
    @estado_esperado = final
    @genes = []
    @fitness = -1
    @probabilidade = 0.01
  end

  #
  # Exibicao do objeto como string.
  #
  def to_s
    s = "("
    @genes.each do |c|
      s += "#{c}, "
    end

    s[-2] = ""
    s[-1] = ")"

    s
  end

  #
  # Gera genes aleatorios. Corresponde ao nascimento do cromossomo na
  # primeira populacao.
  #
  # Movimentos: 0 (esquerda), 1 (cima), 2 (baixo), 3 (direita)
  #
  def gerar_novo
    @genes = []

    1.upto @tamanho do |i|
	    @genes[i-1] = rand(4)
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
      @genes[pos] = 3 - @genes[pos]
    end
  end

  #
  # Retorna primeira metade dos genes.
  #
  def heranca_1
    @genes[0..(@tamanho/2)-1]
  end

  #
  # Retorna segunda metade dos genes.
  #
  def heranca_2
    @genes[@tamanho/2..@tamanho-1]
  end

  def alterar_probabilidade_de_mutacao(valor)
    @probabilidade = valor.to_f
  end

  ############ Metodos privados ############
  private

  #
  # Calcula valor numerico da funcao fitness
  # do cromossomo.
  #
  def calcular_fitness
    resultado = matriz_resultado()
    @fitness = 0

    resultado.each_index do |linha|
      linha.each_index do |coluna|
        esperado = @estado_esperado.index(resultado[linha][coluna])
        if esperado.linha == linha and esperado.coluna == coluna
          @fitness += 1
        end
      end
    end
  end

  #
  # Sorteia uma posicao entre o codigo genetico.
  #
  def sortear_posicao
    rand(@tamanho-1)
  end

  #
  # Calcula a probabilidade de mutacao e
  # verifica se a mutacao e' desejada.
  #
  def deve_mutar?
  	num = (rand(1000)+1).to_f/1000.to_f
    num <= @probabilidade
  end

  def matriz_resultado
    guia = posicao_da_peca_guia()
    resultado = @jogo_usuario.dup

    @genes.each do |movimento|
      case movimento
        when 0 # esquerda
          if guia[:coluna] != 0
            resultado[guia[:linha]][guia[:coluna]] = resultado[guia[:linha]][guia[:coluna]-1]
            resultado[guia[:linha]][guia[:coluna]-1] = 0
          end

        when 1 # cima
          if guia[:linha] != 0
            resultado[guia[:linha]][guia[:coluna]] = resultado[guia[:linha]-1][guia[:coluna]]
            resultado[guia[:linha]-1][guia[:coluna]] = 0
          end

        when 2 # baixo
          if guia[:linha] != resultado.size-1
            resultado[guia[:linha]][guia[:coluna]] = resultado[guia[:linha]+1][guia[:coluna]]
            resultado[guia[:linha]+1][guia[:coluna]] = 0
          end

        when 3 # direita
          if guia[:coluna] != resultado.first.size-1
            resultado[guia[:linha]][guia[:coluna]] = resultado[guia[:linha]][guia[:coluna]+1]
            resultado[guia[:linha]][guia[:coluna]+1] = 0
          end
      end
    end

    resultado
  end

  def posicao_da_peca_guia
    @jogo_usuario.each_index do |linha|
      # peca guia eh simbolizada por 0 (zero)
      coluna = @jogo_usuario[linha].index(0)
      unless coluna.nil?
        return {:linha => linha, :coluna => coluna}
      end
    end
  end
end

















