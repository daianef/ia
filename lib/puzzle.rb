#
# Classes que auxiliam na representacao e tratamento do
#  Sliding Puzzle.
#

#
# Classe que representa uma peca na solucao do jogo.
# Cada Peca tem um valor (inteiro) e uma coordenada (linha, coluna).
#
class Peca
  # Permissao de leitura para valor da peca
  attr_accessor :id

  #
  # Inicializacao de uma Peca com valor, linha e coluna.
  #
  def initialize(id, linha, coluna)
    @id = id.to_i
    @coord = {:linha => linha, :coluna => coluna}
  end

  #
  # Retorna par de coordenadas da Peca.
  #
  def coord
    "#{@coord[:linha]},#{@coord[:coluna]}"
  end

  #
  # Exibe objeto como string.
  #
  def to_s
    "#{@id}(#{@coord[:linha]},#{@coord[:coluna]}) "
  end

  #
  # Mesmo que to_s.
  #
  def inspect
    to_s
  end
end

#
# Classe que representa um jogo Sliding Puzzle NxN.
# Mantem jogo do usuario e a matriz solucao (pos-movimentos).
#
class SlidingPuzzle
  # Permissao de leitura para atributos
  attr_reader :jogo, :estado_esperado

  #
  # Inicializa com arquivo do jogo do usuario.
  #
  def initialize(caminho_arquivo)
    @arquivo = caminho_arquivo
    @jogo = ler_jogo_do_usuario()
    @estado_esperado = obter_estado_esperado()
  end

  def to_s
    msg = "JOGO DO USUARIO: \n"

    @jogo.each do |linha|
      msg += linha.inspect + "\n"
    end

    msg += "ESTADO FINAL ESPERADO: \n"

    @estado_esperado.each do |linha|
      msg += linha.inspect + "\n"
    end

    msg += "N: #{@n.inspect} \n"

    msg
  end

  private

  def ler_jogo_do_usuario
    pecas = []

    File.readlines(@arquivo).each do |line|
      next unless line.match(/\w+/)

      pecas << line.split(" ")
      pecas.last.map! {|peca| peca.to_i}
      @n ||= pecas.last.size

      raise "Jogo invalido!" unless @n == pecas.last.size
    end

    raise "Jogo invalido!" unless pecas.first.size == pecas.size

    pecas
  end

  def obter_estado_esperado
    solucao = []
    peca_atual = 1

    0.upto @n-1 do |linha|
      0.upto @n-1 do |coluna|
        solucao[peca_atual-1] = Peca.new(peca_atual, linha, coluna)
        peca_atual += 1
      end
    end

    solucao_tmp = [solucao.last] + solucao
    solucao_tmp.pop

    solucao_tmp.first.id = 0

    solucao_tmp
  end
end



