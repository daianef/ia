#
# Um cromossomo contem uma sequencia de passos da peca guia (espaco vazio).
# Assim, cada gene e' um movimento.
#

class Cromossomo
  # Permissao de leitura para atributos
  attr_reader :fitness, :resultante, :genes

  #
  # Construtor da classe.
  # Inicia o cromossomo com numero de genes (tamanho), jogo fornecido
  #  pelo usuario (atual) e estado final esperado para o puzzle (final).
  #
  #
  def initialize(tamanho, atual, final)
    raise "Tamanho deve ser igual ou maior que 4." if tamanho.to_i < 4
    raise "Parametro atual deve ser Array." unless atual.is_a? Array
    raise "Parametro final deve ser Array." unless final.is_a? Array

    # Numero de genes
    @tamanho = tamanho.to_i
    # Jogo fornecido pelo usuario
    @jogo_usuario = atual
    # Estado final esperado para as pecas
    @estado_esperado = final
    # Array de genes
    @genes = []
    # Valor da funcao fitness
    @fitness = -1
    # Probabilidade de mutacao
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
  #  primeira populacao.
  #
  # Movimentos: 0 (esquerda), 1 (cima), 2 (baixo), 3 (direita)
  #
  def gerar_novo
    @genes = []
    1.upto @tamanho do |i|
      @genes << rand(4)
    end

    calcular_fitness()
  end

  #
  # Se numero de genes eh divisivel por 4, realiza um crossover que usa
  #  uma especie de embaralhamento a partir de 4 partes:
  #
  #     PAI 1
  # 1 2 3 0 1 2 3 0
  #     --- ---
  # parte_1 = [1, 2]
  # parte_2 = [3, 0]
  #
  #     PAI 2
  # 0 2 3 1 0 2 3 1
  # ---         ---
  # parte_3 = [3, 1]
  # parte_4 = [0, 2]
  #
  # Resultado: 1 2 3 0 3 1 0 2
  #
  # --
  #
  # Se nao, realiza cruzamento simples.
  #
  def crossover(pai1, pai2)
    if @tamanho%4 == 0
      parte_1 = pai1.genes[(@tamanho/2)..(@tamanho/2 + @tamanho/4 - 1)]
      parte_2 = pai1.genes[(@tamanho/2 - @tamanho/4)..(@tamanho/2 - 1)]
      parte_3 = pai2.genes[(@tamanho - @tamanho/4)..(@tamanho - 1)]
      parte_4 = pai2.genes[0..(@tamanho/4 - 1)]

      @genes = parte_1 + parte_2 + parte_3 + parte_4
    else
      @genes = pai1.genes[0..((@tamanho/2)-1)] + pai2.genes[(@tamanho/2)..(@tamanho-1)]
    end

    calcular_fitness()
  end

  #
  # Processo de mutacao e' probabilistico. Posicao de mutacao e'
  #  aleatoria se existe probabilidade de mutacao.
  #
  # Atualmente, se existe probabilidade de mutacao, dois genes sao
  #  mutados (nao multados!).
  #
  def mutacao
    raise "O cromossomo deve possuir genes." if @genes.empty?

    if deve_mutar?
      pos = sortear_posicao()
      @genes[pos] = 3 - @genes[pos]
      calcular_fitness()
    end
  end

  #
  # Altera valor da variavel que armazena a
  #  probabilidade de mutacao do cromossomo.
  #
  def alterar_probabilidade_de_mutacao(valor)
    @probabilidade = valor.to_f
  end

  ############ Metodos privados ############
  private

  #
  # Calcula valor numerico da funcao fitness
  #  do cromossomo.
  #
  def calcular_fitness
    @resultante, movimentos_validos = matriz_resultante()
    @fitness = 0

    @resultante.each_index do |linha|
      @resultante[linha].each_index do |coluna|
        index = @resultante[linha][coluna]
        # Ganha 1 ponto por peca no lugar correto
        if "#{linha},#{coluna}" == @estado_esperado[index].coord()
          @fitness += 1
        end
      end

      # Ganha 1 ponto por linha correta
      if @resultante[linha] == @estado_esperado[linha]
        @fitness += 1
      end
    end

    # Ganha pontos por movimentos validos
    @fitness += movimentos_validos

    # Tira 1 ponto da fitness a cada par de movimentos inutil:
    # e.g. 0 3 (foi para esquerda e foi para direita - ou seja, voltou ao mesmo lugar)
    0.upto (@tamanho-2) do |i|
      par_movimentos = @genes[i..(i+1)]
      if par_movimentos.include? 0 and par_movimentos.include? 3
        @fitness -= 1
      elsif par_movimentos.include? 1 and par_movimentos.include? 2
        @fitness -= 1
      end
    end
  end

  #
  # Sorteia uma posicao entre o codigo genetico.
  #
  def sortear_posicao
    rand(@tamanho)
  end

  #
  # Calcula a probabilidade de mutacao e
  #  verifica se a mutacao e' desejada.
  #
  def deve_mutar?
  	num = (rand(1000)+1).to_f/1000.to_f
    num <= @probabilidade
  end

  #
  # Calcula posicao das pecas apos movimentos representados pelos
  #  genes. Movimentos invalidos sao ignorados.
  #
  def matriz_resultante
    # Obtem posicao da peca guia
    guia = posicao_da_peca_guia()
    # Forca copia de um "array de array", visando evitar que a
    #  variavel resultado seja um ponteiro para @jogo_usuario.
    resultado = Marshal.load(Marshal.dump(@jogo_usuario))
    # Ira' contar o numero de pecas invertidas, visando contabilizar
    #  movimentos validos
    movimentos_validos = 0

    @genes.each do |movimento|
      case movimento
        when 0 # esquerda
          if guia[:coluna] != 0
            resultado[guia[:linha]][guia[:coluna]] = resultado[guia[:linha]][guia[:coluna]-1]
            resultado[guia[:linha]][guia[:coluna]-1] = 0
            guia[:coluna] = guia[:coluna]-1
            movimentos_validos += 1
          end

        when 1 # cima
          if guia[:linha] != 0
            resultado[guia[:linha]][guia[:coluna]] = resultado[guia[:linha]-1][guia[:coluna]]
            resultado[guia[:linha]-1][guia[:coluna]] = 0
            guia[:linha] = guia[:linha]-1
            movimentos_validos += 1
          end

        when 2 # baixo
          if guia[:linha] != resultado.size-1
            resultado[guia[:linha]][guia[:coluna]] = resultado[guia[:linha]+1][guia[:coluna]]
            resultado[guia[:linha]+1][guia[:coluna]] = 0
            guia[:linha] = guia[:linha]+1
            movimentos_validos += 1
          end

        when 3 # direita
          if guia[:coluna] != resultado.first.size-1
            resultado[guia[:linha]][guia[:coluna]] = resultado[guia[:linha]][guia[:coluna]+1]
            resultado[guia[:linha]][guia[:coluna]+1] = 0
            guia[:coluna] = guia[:coluna]+1
            movimentos_validos += 1
          end
      end
    end

    return resultado, movimentos_validos
  end

  #
  # Obtem a posicao da peca guia no jogo
  #  originalmente fornecido pelo usuario.
  #
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

