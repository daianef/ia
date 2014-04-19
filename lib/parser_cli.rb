#!/usr/bin/env ruby
require 'optparse'

class ParserCLI

  def initialize
    @opcoes = {}
    parser()
  end  
  
  def arquivo
    @opcoes[:arquivo]
  end
  
  def probabilidade_de_mutacao
    @opcoes[:prob] || 0.05
  end
  
  def tamanho_do_cromossomo
    @opcoes[:cromo] || 8
  end
  
  def tamanho_da_populacao
    @opcoes[:pop] || 100
  end
  
  def numero_de_geracoes
    @opcoes[:geracoes] || 100
  end
  
  def numero_de_sorteios
    @opcoes[:sorteios] || 3
  end
  
  private
 
  def parser
    opcoes = OptionParser.new do |ops|
      ops.banner = "Uso: ruby solucao_sliding_puzzle.rb -j arquivo_com_jogo.txt [opcoes]"

      ops.on("-j arquivo_com_jogo.txt", "Arquivo (txt) com a descricao do jogo.") do |arquivo|
        @opcoes[:arquivo] = arquivo
      end
     
      ops.on("-p probabilidade_de_mutacao", "Float que indica probabilidade de mutacao.") do |prob|
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
      
      ops.on_tail("-h", "--help", "Mostra esta mensagem.") do
        puts ops
        exit
      end
    end

    opcoes.parse!
    
    if @opcoes[:arquivo].nil? 
      puts "\n\n[ERRO] Voce deve fornecer um arquivo contendo o jogo a ser solucionado.\n\n"
      exit(1)
    end
  end
end
