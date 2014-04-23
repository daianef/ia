require 'optparse'

#
# Classe que trata e fornece as opcoes da
#  linha de comando.
#
class ParserCLI

  #
  # Construtor da classe.
  # O atributo @opcoes armazena as opcoes parseadas
  #  da linha de comando.
  #
  def initialize
    @opcoes = {}
    parser()
  end

  #
  # Devolve nome do arquivo fornecido pelo usuario.
  #
  def arquivo
    @opcoes[:arquivo]
  end

  #
  # Devolve a probabilidade de mutacao escolhida pelo
  #  usuario ou um valor padrao, se nada tiver sido
  #  fornecido.
  #
  def probabilidade_de_mutacao
    @opcoes[:prob] || 0.05
  end

  #
  # Devolve o tamanho do cromossomo escolhido pelo
  #  usuario ou um valor padrao, se nada tiver sido
  #  fornecido.
  #
  def tamanho_do_cromossomo
    @opcoes[:cromo]
  end

  #
  # Devolve o tamanho da populacao escolhido pelo
  #  usuario ou um valor padrao, se nada tiver sido
  #  fornecido.
  #
  def tamanho_da_populacao
    @opcoes[:pop] || 100
  end

  #
  # Devolve o numero de geracoes escolhido pelo
  #  usuario ou um valor padrao, se nada tiver sido
  #  fornecido.
  #
  def numero_de_geracoes
    @opcoes[:geracoes] || 100
  end

  #
  # Devolve o numero de sorteios (usado na escolha dos pais)
  #  escolhido pelo usuario ou um valor padrao, se nada
  #  tiver sido fornecido.
  #
  def numero_de_sorteios
    @opcoes[:sorteios] || 3
  end
  
  #
  # Informa se e' desejado imprimir o resultado final da movimentacao
  #  das pecas, ao lado do valor da fitness.
  #
  def imprimir_resultado?
    @opcoes[:resultado]
  end

  #
  # Informa se e' desejado desabilitar o elitismo.
  #
  def remover_elitismo?
    @opcoes[:sem_elitismo]
  end
  
  private

  #
  # Metodo que analisa a linha de comando e obtem os parametros
  #  fornecidos pelo usuario.
  #
  def parser
    opcoes = OptionParser.new do |ops|
      ops.banner = "Uso: ruby solucao_sliding_puzzle.rb -j arquivo_com_jogo [opcoes]"

      ops.on("-j arquivo_com_jogo", "(Parametro obrigatorio) Arquivo texto com a descricao do jogo.") do |arquivo|
        @opcoes[:arquivo] = arquivo
      end

      ops.on("-p probabilidade_de_mutacao", "Float que indica probabilidade de mutacao (separador de decimal deve ser ponto).") do |prob|
        if prob.to_f > 1
          @opcoes[:prob] = prob.to_f/100
        else
          @opcoes[:prob] = prob.to_f
        end
      end

      ops.on("-n tamanho_do_cromossomo", "Numero de genes de um cromossomo (numero de movimentos para formar uma solucao candidata).") do |cromo|
        @opcoes[:cromo] = cromo.to_i
      end

      ops.on("-N tamanho_da_populacao", "Numero de cromossomos em uma populacao.") do |pop|
        @opcoes[:pop] = pop.to_i
      end

      ops.on("-g numero_de_geracoes", "Numero de populacoes geradas para tentar solucionar o problema.") do |geracoes|
        @opcoes[:geracoes] = geracoes.to_i
      end

      ops.on("-s numero_de_sorteios", "Numero de sorteios na escolha dos pais.") do |sorteios|
        @opcoes[:sorteios] = sorteios.to_i
      end
      
      ops.on("--resultado", "Imprime posicao final das pecas ao lado do valor da fitness.") do |imprimir|
        @opcoes[:resultado] = true
      end
      
      ops.on("--sem_elitismo", "Nao realiza o elitismo nas populacoes.") do |elitismo|
        @opcoes[:sem_elitismo] = true
      end

      ops.on_tail("-h", "--help", "Mostra esta mensagem.") do
        puts ops
        exit
      end
    end

    opcoes.parse!

    if @opcoes[:arquivo].nil?
      puts "\n\n[ERRO] Voce deve fornecer, pelo menos, um arquivo contendo o jogo a ser solucionado.\n\n"
      puts opcoes
      exit(1)
    end
  end
end

