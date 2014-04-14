# Configuracao do jogo
# TODO: tornar parametrizavel e de qualquer tamanho
#
# 3 2 1
# 6 5 4
# 7 8 #
#


class Peca
  def initialize(id, linha, coluna)
    @id = id.to_i
    @coord = {:linha => linha, :coluna => coluna}
  end

  def linha
    @coord[:linha]
  end

  def coluna
    @coord[:coluna]
  end

  def <=>(outro)
    @id <=> outro.id
  end

  def ==(outro)
    @id == outro.id
  end

  def to_s
    "#{@id}(#{@coord[:linha]},#{@coord[:coluna]}) "
  end

  def inspect
    to_s
  end
end

#
# Classe que representa um jogo Sliding Puzzle NxN.
# Mantem jogo do usuario e a matriz solucao.
#
class SlidingPuzzle
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

    solucao[@n*@n-1] = Peca.new(0, @n-1, @n-1)

    solucao
  end
end

sp = SlidingPuzzle.new("/media/ARQUIVOS/ENGENHARIA/IA/trabalho/teste.txt")
puts sp
