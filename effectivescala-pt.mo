<a href="http://github.com/twitter/effectivescala"><img style="position: absolute; top: 0; left: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_left_green_007200.png" alt="Fork me on GitHub"></a>

<h1 class="header">Effective Scala</h1>
<address>Marius Eriksen, Twitter Inc.<br />marius@twitter.com (<a href="http://twitter.com/marius">@marius</a>)</address>

<h2>Sumário</h2>

.TOC


<h2>Outros idiomas</h2>
<a href="index.html">English</a>
<a href="index-ja.html">日本語</a>
<a href="index-ru.html">Русский</a>
<a href="index-cn.html">简体中文</a>


## Introdução

[Scala][Scala] é uma das principais linguagens de programação de aplicações
usadas no Twitter. Muito da nossa infraestrutura está escrita em Scala e
[nós possuímos diversas bibliotecas extensas](http://github.com/twitter/)
para suportar o nosso uso. Embora altamente efetiva, Scala é também uma
linguagem grande, e nossa experiência nos ensinou a exercitar a cautela
em sua utilização. Quais são suas armadilhas? Quais funcionalidades nós
abraçamos, quais evitamos? Quando empregamos o "estilo puramente funcional",
e quando fugimos dele? Em outras palavras: qual modo de uso da linguagem
nós descobrimos ser efetivo? Esse guia é uma tentativa de extrair nossa
experiência em curtos artigos, fornecendo um conjunto de *melhores
práticas*. Utilizamos Scala principalmente na criação de serviços de
alto volume que compõem sistemas distribuídos -- e nossas sugestões são,
portanto, enviesadas -- mas a maioria dos conselhos aqui contidos deve
ser naturalmente aplicável em outros domínios. Estas não são leis, mas
o seu desvio deve ser bem justificado.

Scala fornece vários instrumentos que possibilitam expressões sucintas.
Menos digitação é menos leitura, menos leitura é frequentemente leitura
mais rápida, e assim a brevidade eleva a clareza. Contudo, a brevidade
é uma ferramenta brusca que também pode resultar no efeito oposto:
depois da corretude, pense sempre no leitor.

Acima de tudo, *programe em Scala*. Você não está escrevendo Java,
nem Haskell, tampouco Python; um programa em Scala é diferente de
um escrito em qualquer uma dessas. Para um uso efetivo, você deve
expressar seus problemas nos termos da linguagem. De nada adianta
forçar um programa de Java para Scala, pois será inferior ao
original na maioria dos aspectos.

Essa não é uma introdução ao Scala; nós assumimos que o leitor
possui familiaridade com a linguagem. Alguns recursos para aprender
Scala são:

* [Scala School](http://twitter.github.com/scala_school/)
* [Learning Scala](http://www.scala-lang.org/node/1305)
* [Learning Scala in Small Bites](http://matt.might.net/articles/learning-scala-in-small-bites/)

Esse é um documento em evolução, que mudará para refletir as nossas
atuais "melhores práticas", mas o seu núcleo de ideias dificilmente
será alterado: Sempre favoreça a legibilidade; escreva código
genérico mas não em detrimento da clareza; aproveite-se de
funcionalidades simples da linguagem que concedem grande poder,
mas evite funcionalidades esotéricas (especialmente relacionadas
ao sistema de tipos). Sobretudo, esteja sempre ciente dos
trade-offs de suas escolhas. Uma linguagem sofisticada requer uma
implementação complexa, e complexidade gera complexidade: de
raciocínio, de semântica, de interação entre funcionalidades, e
de compreensão entre os seus colaboradores. Portanto, a complexidade
é uma tarifa da sofisticação -- e você deve sempre garantir que sua
utilidade excede o seu custo.

E divirta-se.

## Formatação

Os detalhes da *formatação* de código - desde que sejam práticos -
possuem poucas consequências. Por definição, estilo não é inerentemente
bom ou ruim, é questão de preferência pessoal. No entanto, a aplicação
*consistente* das mesmas regras de formatação quase sempre aprimora
a legibilidade. Um leitor já familiarizado com um determinado estilo
não precisa assimilar ainda mais um conjunto de convenções locais, ou
decifrar outro canto obscuro da gramática da linguagem.

Isso é de particular importância no Scala, já que sua gramática
possui um alto grau de intersecção. Um exemplo revelador é a invocação
de método: Métodos podem ser invocados com "`.`", com um espaço, sem
parênteses para métodos nulários ou unários, com parênteses para
esses e outros e assim por diante. Ademais, os diferentes estilos
de invocação de método expõem diferentes ambiguidades na gramática!
Certamente, a aplicação consistente de um conjunto de regras de
formatação cuidadosamente escolhido solucionará uma grande dose de
ambiguidade, tanto para o homem quanto para a máquina.

Somos adeptos do [Scala style guide](http://docs.scala-lang.org/style/)
e das regras a seguir.

### Espaços

Indente com dois espaços. Tente evitar linhas com mais de 100 colunas
de comprimento. Use uma linha em branco entre definições de métodos,
classes e objetos.

### Nomeação

<dl class="rules">
<dt>Use nomes pequenos para escopos pequenos</dt>
<dd> <code>i</code>s, <code>j</code>s e <code>k</code>s são esperados
em loops. </dd>
<dt>Use nomes mais longos para escopos maiores</dt>
<dd>APIs externas devem possuir nomes longos e explicativos, que possuam significado.
<code>Future.collect</code> e não <code>Future.all</code>.
</dd>
<dt>Use abreviaturas comuns mas evite as esotéricas</dt>
<dd>
Todos conhecem <code>ok</code>, <code>err</code> ou <code>defn</code>
enquanto <code>sfri</code> não é tão comum.
</dd>
<dt>Não reutilize nomes para propósitos diferentes</dt>
<dd>Use <code>val</code>s</dd>
<dt>Evite usar <code>`</code>s para sobrecarregar nomes reservados</dt>
<dd><code>typ</code> ao invés de <code>`type</code>`</dd>
<dt>Use nomes ativos para operações com efeitos colaterais</dt>
<dd><code>user.activate()</code> e não <code>user.setActive()</code></dd>
<dt>Use nomes descritivos para métodos que retornam valores</dt>
<dd><code>src.isDefined</code> e não <code>src.defined</code></dd>
<dt>Não prefixe getters com <code>get</code></dt>
<dd>Assim como a regra anterior, é redundante: <code>site.count</code> e não <code>site.getCount</code></dd>
<dt>Não repita nomes que já estão encapsulados no nome do pacote ou do objeto</dt>
<dd>Prefira:
<pre><code>object User {
  def get(id: Int): Option[User]
}</code></pre> a
<pre><code>object User {
  def getUser(id: Int): Option[User]
}</code></pre>Eles são redundantes no seu uso: <code>User.getUser</code> não
provê mais informações que <code>User.get</code>.
</dd>
</dl>


### Imports

<dl class="rules">
<dt>Ordene as linhas de import alfabeticamente</dt>
<dd>Isso faz com que fique fácil de examinar visualmente, e é fácil de automatizar.</dd>
<dt>Use chaves ao importar múltiplos nomes de um pacote</dt>
<dd><code>import com.twitter.concurrent.{Broker, Offer}</code></dd>
<dt>Use wildcards quando mais de seis nomes são importados</dt>
<dd>ex: <code>import com.twitter.concurrent._</code>
<br />Não aplique essa técnica cegamente: alguns pacotes exportam nomes demais</dd>
<dt>Ao usar coleções, classifique os nomes na importação
<code>scala.collection.immutable</code> e/ou <code>scala.collection.mutable</code></dt>
<dd>Coleções mutáveis e imutáveis possuem duplicidade de nomes.
Classificar os nomes torna obvio ao leitor qual variante está sendo utilizada. (ex. "<code>immutable.Map</code>")</dd>
<dt>Não use imports relativos de outros pacotes</dt>
<dd>Evite <pre><code>import com.twitter
import concurrent</code></pre> e favoreça <pre><code>import com.twitter.concurrent</code></pre></dd>
<dt>Coloque os imports no início do arquivo</dt>
<dd>O leitor pode consultar todos os imports em um lugar.</dd>
</dl>

### Chaves

Chaves são utilizadas para criar expressões compostas (elas possuem
outros usos na "linguagem de módulos"), onde o valor da expressão
composta é a última expressão do conjunto. Evite usar chaves para
expressões simples; escreva

	def square(x: Int) = x*x

.LP e não

	def square(x: Int) = {
	  x * x
	}

.LP mesmo que seja tentador distinguir sintaticamente o corpo do método. A primeira alternativa é mais limpa e legível. <em>Evite cerimonial sintático</em> exceto quando deixa o código mais claro.

### Pattern matching

Use o casamento de padrões diretamente na definição das funções quando aplicável;
ao invés de

	list map { item =>
	  item match {
	    case Some(x) => x
	    case None => default
	  }
	}

.LP compacte o match

	list map {
	  case Some(x) => x
	  case None => default
	}

.LP fica claro que os itens da lista estão sendo mapeados &mdash; a indireção adicional não ajuda na elucidação.

### Comentários

Use [ScalaDoc](https://wiki.scala-lang.org/display/SW/Scaladoc) para
a documentação de APIs. Utilize o seguinte estilo:

	/**
	 * ServiceBuilder builds services
	 * ...
	 */

.LP e <em>não</em> o estilo ScalaDoc padrão:

	/** ServiceBuilder builds services
	 * ...
	 */

Não recorra à arte ASCII ou outras ornamentações visuais. Documente APIs
mas não acrescente comentários desnecessários. Caso esteja escrevendo
comentários para explicar o comportamento do código, primeiro questione
se ele pode ser reestruturado de forma a tornar óbvio o que faz. Prefira
"obviamente funciona" a "funciona, obviamente" (com desculpas ao Hoare).

## Tipos e Generics

O objetivo primário de um sistema de tipos é a detecção de erros de
programação. Efetivamente, o sistema de tipos provê uma forma limitada de
validação estática, permitindo-nos expressar certas invariáveis sobre o
nosso código que o compilador pode verificar. É claro que os sistemas de
tipos também possuem outros benefícios, mas a verificação de erros é sua
Raison d&#146;&Ecirc;tre.

A nossa utilização do sistema de tipos deve refletir esse objetivo, mas
sem esquecer do leitor: o uso apropriado da tipagem pode aprimorar a
clareza, enquanto ser demasiadamente engenhoso apenas obscurece.

O poderoso sistema de tipos do Scala é uma fonte comum de exploração
e exercício acadêmico (ex. [Type level programming in
Scala](http://apocalisp.wordpress.com/2010/06/08/type-level-programming-in-scala/)).
Embora um tópico acadêmico fascinante, essas técnicas raramente são
úteis em código de produção. Elas devem ser evitadas.

### Anotações com o tipo de retorno

Embora o Scala permita que as mesmas sejam omitidas, elas servem de
documentação: isso é especialmente importante para métodos públicos.
Quando um método não estiver exposto e seu tipo de retorno é óbvio,
omita-as.

As anotações são fundamentais ao instanciar objetos com mixins, já que
o compilador do Scala cria um tipo singleton para esses casos. Por
exemplo, o método `make` em:

	trait Service
	def make() = new Service {
	  def getId = 123
	}

.LP <em>não</em> possui um tipo de retorno <code>Service</code>; o compilador cria um tipo refinado <code>Object with Service{def getId: Int}</code>. Ao contrário, use uma anotação explícita:

	def make(): Service = new Service{}

Agora, o autor fica livre para adicionar mais feições sem alterar o
tipo público de `make`, facilitando o gerenciamento de compatibilidade
reversa.

### Variância

Variância acontece quando a programação genérica é combinada com a
subtipagem. Ela define como a subtipagem do tipo *contido* se relaciona
com a subtipagem do tipo do *container*. Como o Scala possui anotações
de variância declarativas, autores de bibliotecas comuns -- especialmente
coleções -- devem ser anotadores prolíficos. Essas anotações são
importantes para a usabilidade do código compartilhado, e seu mau
uso pode ser perigoso.

Invariantes são um aspecto avançado, porém necessário, do sistema de
tipos do Scala e devev ser usadas extensamente (e corretamente) já que
auxiliam na aplicação da subtipagem.

*Coleções imutáveis devem ser covariantes*. Métodos que recebem o
tipo contido devem "rebaixar" a coleção apropriadamente:

	trait Collection[+T] {
	  def add[U >: T](other: U): Collection[U]
	}

*Coleções mutáveis devem ser invariantes*. Covariância é,
geralmente, incompatível com coleções mutáveis. Considere

	trait HashSet[+T] {
	  def add[U >: T](item: U)
	}

.LP e a seguinte hierarquia de tipos:

	trait Mammal
	trait Dog extends Mammal
	trait Cat extends Mammal

.LP se agora possuo um HashSet do tipo Dog

	val dogs: HashSet[Dog]

.LP e trato-o como um set de Mammals para adicionar um Cat

	val mammals: HashSet[Mammal] = dogs
	mammals.add(new Cat{})

.LP ele deixa de ser um HashSet do tipo Dog.

<!--
  *	when to use abstract type members?
  *	show contravariance trick?
-->

### Alias de tipo

Utilize alias de tipos quando eles fornecem uma nomeação
conveniente ou propósito de clarificação, mas não quando são
auto-explicativos.

	() => Int

.LP é mais claro que

	type IntMaker = () => Int
	IntMaker

.LP pois é curto e usa um tipo comum. Contudo

	class ConcurrentPool[K, V] {
	  type Queue = ConcurrentLinkedQueue[V]
	  type Map   = ConcurrentHashMap[K, Queue]
	  ...
	}

.LP é benéfico já que comunica propósito e aprimora a brevidade.

Não utilize a herança quando um alias é suficiente.

	trait SocketFactory extends (SocketAddress => Socket)

.LP um <code>SocketFactory</code> <em>é</em> uma função que produz um <code>Socket</code>. Usar um alias de tipo

	type SocketFactory = SocketAddress => Socket

.LP é melhor. Agora podemos providenciar funções literais para valores do tipo <code>SocketFactory</code> e também usufruir da composição de funções:

	val addrToInet: SocketAddress => Long
	val inetToSocket: Long => Socket

	val factory: SocketFactory = addrToInet andThen inetToSocket

Alias de tipo são amarradas a nomes de topos ao usar package objects:

	package com.twitter
	package object net {
	  type SocketFactory = (SocketAddress) => Socket
	}

Note que alias de tipos não são novos tipos -- eles são equivalentes
a substituição sintática do alias pelo seu tipo.

### Implicits

Implicits é uma funcionalidade poderosa do sistema de tipos, mas deve
ser usada esporadicamente. Ela possui regras de resolução complexas
e torna complicada -- por simples análise léxica -- a compreensão do
que está acontecendo. É definitivamente aceitável usar implicits nas
seguintes situações:

* Extender ou acrescentar uma coleção estilo Scala
* Adaptar ou extender um objeto (padrão "pimp my library")
* *Aprimorar a segurança de tipos* providenciando evidência restritiva
* Fornecer evidência de tipos (typeclasses)
* Para `Manifest`os

Caso encontre-se utilizando implicits, sempre se pergunte se existe
outra maneira de alcançar o mesmo objetivo.

Não use implicits para efetuar a conversão automática entre tipos
similares (por exemplo, conversão de list para stream); é melhor
realiza-la explicitamente pois os tipos possuem semânticas diferentes
e o leitor deve estar ciente das implicações.

## Coleções

Scala possui uma biblioteca de coleções bastante genérica, rica,
poderosa e modular; coleções são de alto nível e expõem um grande
conjunto de operações. Muitas manipulações e transformações de
coleções podem ser expressadas de forma sucinta e legível, embora
a aplicação descuidada dessas funcionalidades possa frequentemente
levar ao resultado oposto. Todo programador Scala deve ler o
[documento de design de coleções](http://www.scala-lang.org/docu/files/collections-api/collections.html);
ele fornece a visão e motivação da biblioteca de coleções do Scala.

Sempre utilize a coleção mais simples que satisfaça suas necessidades.

### Hierarquia

A biblioteca de coleções é enorme: em adição a uma hierarquia
elaborada -- cuja raiz é `Traversable[T]` -- existem variantes
`imutáveis` e `mutáveis` para a maioria das coleções. Independente
da complexidade, o seguinte diagrama contem as distinções
importantes n as hierarquias `imutável` e `mutável`

<img src="coll.png" style="margin-left: 3em;" />
.cmd
pic2graph -format png >coll.png <<EOF 
boxwid=1.0

.ft I
.ps +9

Iterable: [
	Box: box wid 1.5*boxwid
	"\s+2Iterable[T]\s-2" at Box
]

Seq: box "Seq[T]" with .n at Iterable.s + (-1.5, -0.5)
Set: box "Set[T]" with .n at Iterable.s + (0, -0.5)
Map: box "Map[T]" with .n at Iterable.s + (1.5, -0.5)

arrow from Iterable.s to Seq.ne
arrow from Iterable.s to Set.n
arrow from Iterable.s to Map.nw
EOF
.endcmd

.LP <code>Iterable[T]</code> é qualquer coleção que pode ser iterada, elas provêm um método <code>iterator</code> (e, consequentemente, <code>foreach</code>). <code>Seq[T]</code>s são coleções <em>ordenadas</em>, <code>Set[T]</code>s são conjuntos matemáticos (coleções não ordenadas de itens únicos), e <code>Map[T]</code>s são arrays associativos, também não ordenados.

### Uso

*Prefira utilizar coleções imutáveis.* Elas são aplicáveis na maioria
das circunstâncias, favorecem o racioncínio sobre os programas já
que são referenciamente transparentes e, portanto, thread-safe por
padrão.

favorecem o raciocínio sobre os programas
facilitam

*Use o namespace `mutable` explicitamente.* Não importe
`scala.collection.mutable._` e faça referência a `Set`, ao contrário

	import scala.collection.mutable
	val set = mutable.Set()

.LP torna mais claro que a variante mutável está sendo utilizada.

*Use o construtor padrão do tipo da coleção.* Sempre que precisar de
uma sequência ordenada (e não necessariamente da semântica de listas
encadeadas), utilize o construtor `Seq()` e assim sucessivamente:

	val seq = Seq(1, 2, 3)
	val set = Set(1, 2, 3)
	val map = Map(1 -> "one", 2 -> "two", 3 -> "three")

.LP Esse estilo separa a semântica da coleção de sua implementação, deixando que a biblioteca de coleções utilize o tipo mais apropriado: você precisa de um <code>Map</code>, não necessariamente de uma Árvore Red-Black. Ademais, os construtores padrões frequentemente utilizam as representações especializadas: por exemplo, <code>Map()</code> usará um objeto com três campos para mapas com três chaves.

O corolário das observações acima é: em seus próprios métodos e construtores,
*receba o tipo genérico mais apropriado da coleção*. Geralmente, acaba sendo
um dos supracitados: `Iterable`, `Seq`, `Set`, ou `Map`. Se o seu método
precisa de uma sequência, use `Seq[T]`, não `List[T]`. (Uma palavra de
precaução: os tipos *padrão* em escopo de `Traversable`, `Iterable` e `Seq`
– definidos no `scala.package` – são as versões presentes em `scala.collection`,
ao contrário de `Map` e `Set` – definidos no `Predef.scala` – que são as
versões de `scala.collection.immutable`. Isso significa que, por exemplo,
o tipo `Seq` padrão pode ser a implementação mutável *e* imutável. Assim,
se seu método depende da imutabilidade de um parâmetro de coleção, você
*deve* importar a variante imutável, ou alguém *poderá* passar a versão
mutável.)

<!--
something about buffers for construction?
anything about streams?
-->

### Estilo

A programação funcional encoraja o encadeamento de transformações de
uma coleção imutável para chegar até o resultado desejado. Frequentemente,
isso leva a soluções muito sucintas, mas pode ser confuso para o
leitor -- muitas vezes é difícil distinguir a intenção do autor ou
compreender os estados intermediários implícitos. Por exemplo, digamos
que queiramos agregar votos de diferentes linguagens de programação
de uma sequência de (linguagem, num votos), mostrando-as em ordem
decrescente de votos. Poderíamos escrever:

	val votes = Seq(("scala", 1), ("java", 4), ("scala", 10), ("scala", 1), ("python", 10))
	val orderedVotes = votes
	  .groupBy(_._1)
	  .map { case (which, counts) => 
	    (which, counts.foldLeft(0)(_ + _._2))
	  }.toSeq
	  .sortBy(_._2)
	  .reverse

.LP é sucinto e correto, mas quase todos os leitores vão ter dificuldade para identificar a intenção original do autor. Uma estratégia que frequentemente auxilia na clarificação é <em>nomear os resultados e parâmetros intermediários</em>:

	val votesByLang = votes groupBy { case (lang, _) => lang }
	val sumByLang = votesByLang map { case (lang, counts) =>
	  val countsOnly = counts map { case (_, count) => count }
	  (lang, countsOnly.sum)
	}
	val orderedVotes = sumByLang.toSeq
	  .sortBy { case (_, count) => count }
	  .reverse

.LP o código é quase tão sucinto, porém expressa muito mais claramente tanto as transformações que ocorrem (através da nomeação de valores intermediários), quanto a estruturas de dados utilizadas (pela nomeação dos parâmetros). Caso você se preocupe com a poluição do namespace, agrupe as expressões com <code>{}</code>:

	val orderedVotes = {
	  val votesByLang = ...
	  ...
	}


### Performance

Bibliotecas de coleções de alto nível (como geralmente acontece com
construções de alto nível) dificultam o raciocício sobre performance:
quanto mais você se distância de instruir o computador diretamente --
em outras palavras, no estilo imperativo -- mais difícil é de pressupor
as implicações de desempenho de um pedaço de código. Argumentar sobre
a corretude, no entanto, é tipicamente mais fácil; a legibilidade
também é melhorada. Com o Scala, o panorama torna-se ainda mais
complexo devido ao runtime do Java; Scala oculta de você as operações
de boxing/unboxing, e elas podem incorrer em penalizações severas de
performance ou espaço.

Antes de se focar em detalhes de baixo nível, certifique que você
está utilizando uma coleção apropriada para a circunstância. Garanta
que sua estrutura de dados não tem uma complexidade assintótica
inesperada. A complexidade das diversas coleções do Scala são
descritas [aqui](http://www.scala-lang.org/docu/files/collections-api/collections_40.html).

A primeira regra da otimização de performance é compreender o *porquê*
de sua aplicação estar devagar. Não aja sem dados; faça um
profiling^[[Yourkit](http://yourkit.com) é um bom profiler] de sua
aplicação antes de proceder. Atente-se primeiro em loops e grandes
estruturas de dados. Foco excessivo em otimização é, geralmente,
desperdício de esforço. Lembre da máxima de Knuth: "Otimização
prematura é a raiz de todo mal".

É frequentemente apropriado usar coleções de baixo nível em situações
que requerem melhor desempenho ou eficiência de espaço. Use arrays ao
invés de listas para sequências grandes (a coleção imutável `Vector`
fornece uma interface referencialmente transparente para arrays); e
utilize buffers ao invés da construção direta de sequências quando
a performance for importante.

### Coleções Java

Utilize `scala.collection.JavaConverters` para interoperar com coleções
Java. É um conjunto de implicits que adiciona os métodos de conversão
`asJava`e `asScala`. O uso desses garante que as conversões são explícitas,
auxiliando o leitor:

	import scala.collection.JavaConverters._
	
	val list: java.util.List[Int] = Seq(1,2,3,4).asJava
	val buffer: scala.collection.mutable.Buffer[Int] = list.asScala

## Concurrency

Modern services are highly concurrent -- it is common for servers to
coordinate 10s-100s of thousands of simultaneous operations -- and
handling the implied complexity is a central theme in authoring robust
systems software.

*Threads* provide a means of expressing concurrency: they give you
independent, heap-sharing execution contexts that are scheduled by the
operating system. However, thread creation is expensive in Java and is
a resource that must be managed, typically with the use of pools. This
creates additional complexity for the programmer, and also a high
degree of coupling: it's difficult to divorce application logic from
their use of the underlying resources.

This complexity is especially apparent when creating services that
have a high degree of fan-out: each incoming request results in a
multitude of requests to yet another tier of systems. In these
systems, thread pools must be managed so that they are balanced
according to the ratios of requests in each tier: mismanagement of one
thread pool bleeds into another. 

Robust systems must also consider timeouts and cancellation, both of
which require the introduction of yet more "control" threads,
complicating the problem further. Note that if threads were cheap
these problems would be diminished: no pooling would be required,
timed out threads could be discarded, and no additional resource
management would be required.

Thus resource management compromises modularity.

### Futures

Use Futures to manage concurrency. They decouple
concurrent operations from resource management: for example, [Finagle][Finagle]
multiplexes concurrent operations onto few threads in an efficient
manner. Scala has lightweight closure literal syntax, so Futures
introduce little syntactic overhead, and they become second nature to
most programmers.

Futures allow the programmer to express concurrent computation in a
declarative style, are composable, and have principled handling of
failure. These qualities have convinced us that they are especially
well suited for use in functional programming languages, where this is
the encouraged style.

*Prefer transforming futures over creating your own.* Future
transformations ensure that failures are propagated, that
cancellations are signalled, and free the programmer from thinking
about the implications of the Java memory model. Even a careful
programmer might write the following to issue an RPC 10 times in
sequence and then print the results:

	val p = new Promise[List[Result]]
	var results: List[Result] = Nil
	def collect() {
	  doRpc() onSuccess { result =>
	    results = result :: results
	    if (results.length < 10)
	      collect()
	    else
	      p.setValue(results)
	  } onFailure { t =>
	    p.setException(t)
	  }
	}

	collect()
	p onSuccess { results =>
	  printf("Got results %s\n", results.mkString(", "))
	}

The programmer had to ensure that RPC failures are propagated,
interspersing the code with control flow; worse, the code is wrong!
Without declaring `results` volatile, we cannot ensure that `results`
holds the previous value in each iteration. The Java memory model is a
subtle beast, but luckily we can avoid all of these pitfalls by using
the declarative style:

	def collect(results: List[Result] = Nil): Future[List[Result]] =
	  doRpc() flatMap { result =>
	    if (results.length < 9)
	      collect(result :: results)
	    else
	      Future.value(result :: results)
	  }

	collect() onSuccess { results =>
	  printf("Got results %s\n", results.mkString(", "))
	}

We use `flatMap` to sequence operations and prepend the result onto
the list as we proceed. This is a common functional programming idiom
translated to Futures. This is correct, requires less boilerplate, is
less error prone, and also reads better.

*Use the Future combinators*. `Future.select`, `Future.join`, and
`Future.collect` codify common patterns when operating over
multiple futures that should be combined.

*Do not throw your own exceptions in methods that return Futures.*
Futures represent both successful and failed computations. Therefore, it's
important that errors involved in that computation are properly encapsulated in
the returned Future. Concretely, return <code>Future.exception</code> instead of
throwing that exception:

	def divide(x: Int, y: Int): Future[Result] = {
	  if (y == 0)
	    return Future.exception(new IllegalArgumentException("Divisor is 0"))

	  Future.value(x/y)
	}

Fatal exceptions should not be represented by Futures. These exceptions
include ones that are thrown when resources are exhausted, like
OutOfMemoryError, and also JVM-level errors like NoSuchMethodError. These
conditions are ones under which the JVM must exit.

The predicates <code>scala.util.control.NonFatal</code> -- or Twitter's version
<code>com.twitter.util.NonFatal</code> -- should be used to identify exceptions
which should be returned as a Future.exception.

### Collections

The subject of concurrent collections is fraught with opinions,
subtleties, dogma and FUD. In most practical situations they are a
nonissue: Always start with the simplest, most boring, and most
standard collection that serves the purpose. Don't reach for a
concurrent collection before you *know* that a synchronized one won't
do: the JVM has sophisticated machinery to make synchronization cheap,
so their efficacy may surprise you.

If an immutable collection will do, use it -- they are referentially
transparent, so reasoning about them in a concurrent context is
simple. Mutations in immutable collections are typically handled by
updating a reference to the current value (in a `var` cell or an
`AtomicReference`). Care must be taken to apply these correctly:
atomics must be retried, and `vars` must be declared volatile in order
for them to be published to other threads.

Mutable concurrent collections have complicated semantics, and make
use of subtler aspects of the Java memory model, so make sure you
understand the implications -- especially with respect to publishing
updates -- before you use them. Synchronized collections also compose
better: operations like `getOrElseUpdate` cannot be implemented
correctly by concurrent collections, and creating composite
collections is especially error prone.

<!--

use the stupid collections first, get fancy only when justified.

serialized? synchronized?

blah blah.

Async*?

-->


## Control structures

Programs in the functional style tend to require fewer traditional
control structures, and read better when written in the declarative
style. This typically implies breaking your logic up into several
small methods or functions, and gluing them together with `match`
expressions. Functional programs also tend to be more
expression-oriented: branches of conditionals compute values of
the same type, `for (..) yield` computes comprehensions, and recursion
is commonplace.

### Recursion

*Phrasing your problem in recursive terms often simplifies it,* and if
the tail call optimization applies (which can be checked by the `@tailrec`
annotation), the compiler will even translate your code into a regular loop.

Consider a fairly standard imperative version of heap <span
class="algo">fix-down</span>:

	def fixDown(heap: Array[T], m: Int, n: Int): Unit = {
	  var k: Int = m
	  while (n >= 2*k) {
	    var j = 2*k
	    if (j < n && heap(j) < heap(j + 1))
	      j += 1
	    if (heap(k) >= heap(j))
	      return
	    else {
	      swap(heap, k, j)
	      k = j
	    }
	  }
	}

Every time the while loop is entered, we're working with state dirtied
by the previous iteration. The value of each variable is a function of
which branches were taken, and it returns in the middle of the loop
when the correct position was found (The keen reader will find similar
arguments in Dijkstra's ["Go To Statement Considered Harmful"](http://www.u.arizona.edu/~rubinson/copyright_violations/Go_To_Considered_Harmful.html)).

Consider a (tail) recursive
implementation^[From [Finagle's heap
balancer](https://github.com/twitter/finagle/blob/master/finagle-core/src/main/scala/com/twitter/finagle/loadbalancer/Heap.scala#L41)]:

	@tailrec
	final def fixDown(heap: Array[T], i: Int, j: Int) {
	  if (j < i*2) return
	
	  val m = if (j == i*2 || heap(2*i) < heap(2*i+1)) 2*i else 2*i + 1
	  if (heap(m) < heap(i)) {
	    swap(heap, i, m)
	    fixDown(heap, m, j)
	  }
	}

.LP here every iteration starts with a well-defined <em>clean slate</em>, and there are no reference cells: invariants abound. It&rsquo;s much easier to reason about, and easier to read as well. There is also no performance penalty: since the method is tail-recursive, the compiler translates this into a standard imperative loop.

<!--
elaborate..
-->


### Returns

This is not to say that imperative structures are not also valuable.
In many cases they are well suited to terminate computation early
instead of having conditional branches for every possible point of
termination: indeed in the above `fixDown`, a `return` is used to
terminate early if we're at the end of the heap.

Returns can be used to cut down on branching and establish invariants.
This helps the reader by reducing nesting (how did I get here?) and
making it easier to reason about the correctness of subsequent code
(the array cannot be accessed out of bounds after this point). This is
especially useful in "guard" clauses:

	def compare(a: AnyRef, b: AnyRef): Int = {
	  if (a eq b)
	    return 0
	
	  val d = System.identityHashCode(a) compare System.identityHashCode(b)
	  if (d != 0)
	    return d
	    
	  // slow path..
	}

Use `return`s to clarify and enhance readability, but not as you would
in an imperative language; avoid using them to return the results of a
computation. Instead of

	def suffix(i: Int) = {
	  if      (i == 1) return "st"
	  else if (i == 2) return "nd"
	  else if (i == 3) return "rd"
	  else             return "th"
	}

.LP prefer:

	def suffix(i: Int) =
	  if      (i == 1) "st"
	  else if (i == 2) "nd"
	  else if (i == 3) "rd"
	  else             "th"

.LP but using a <code>match</code> expression is superior to either:

	def suffix(i: Int) = i match {
	  case 1 => "st"
	  case 2 => "nd"
	  case 3 => "rd"
	  case _ => "th"
	}

Note that returns can have hidden costs: when used inside of a closure,

	seq foreach { elem =>
	  if (elem.isLast)
	    return
	  
	  // process...
	}
	
.LP this is implemented in bytecode as an exception catching/throwing pair which, used in hot code, has performance implications.

### `for` loops and comprehensions

`for` provides both succinct and natural expression for looping and
aggregation. It is especially useful when flattening many sequences.
The syntax of `for` belies the underlying mechanism as it allocates
and dispatches closures. This can lead to both unexpected costs and
semantics; for example

	for (item <- container) {
	  if (item != 2) return
	}

.LP may cause a runtime error if the container delays computation, making the <code>return</code> nonlocal!

For these reasons, it is often preferrable to call `foreach`,
`flatMap`, `map`, and `filter` directly -- but do use `for`s when they
clarify.

### `require` and `assert`

`require` and `assert` both serve as executable documentation. Both are
useful for situations in which the type system cannot express the required
invariants. `assert` is used for *invariants* that the code assumes (either
internal or external), for example

	val stream = getClass.getResourceAsStream("someclassdata")
	assert(stream != null)

Whereas `require` is used to express API contracts:

	def fib(n: Int) = {
	  require(n > 0)
	  ...
	}

## Functional programming

*Value oriented* programming confers many advantages, especially when
used in conjunction with functional programming constructs. This style
emphasizes the transformation of values over stateful mutation,
yielding code that is referentially transparent, providing stronger
invariants and thus also easier to reason about. Case classes, pattern
matching, destructuring bindings, type inference, and lightweight
closure- and method-creation syntax are the tools of this trade.

### Case classes as algebraic data types

Case classes encode ADTs: they are useful for modelling a large number
of data structures and provide for succinct code with strong
invariants, especially when used in conjunction with pattern matching.
The pattern matcher implements exhaustivity analysis providing even
stronger static guarantees.

Use the following pattern when encoding ADTs with case classes:

	sealed trait Tree[T]
	case class Node[T](left: Tree[T], right: Tree[T]) extends Tree[T]
	case class Leaf[T](value: T) extends Tree[T]
	
.LP The type <code>Tree[T]</code> has two constructors: <code>Node</code> and <code>Leaf</code>. Declaring the type <code>sealed</code> allows the compiler to do exhaustivity analysis since constructors cannot be added outside the source file.

Together with pattern matching, such modelling results in code that is
both succinct and "obviously correct":

	def findMin[T <: Ordered[T]](tree: Tree[T]) = tree match {
	  case Node(left, right) => Seq(findMin(left), findMin(right)).min
	  case Leaf(value) => value
	}

While recursive structures like trees constitute classic applications of
ADTs, their domain of usefulness is much larger. Disjoint unions in particular are
readily modelled with ADTs; these occur frequently in state machines.

### Options

The `Option` type is a container that is either empty (`None`) or full
(`Some(value)`). It provides a safe alternative to the use of `null`,
and should be used instead of null whenever possible. Options are 
collections (of at most one item) and they are embellished with 
collection operations -- use them!

Write

	var username: Option[String] = None
	...
	username = Some("foobar")
	
.LP instead of

	var username: String = null
	...
	username = "foobar"
	
.LP since the former is safer: the <code>Option</code> type statically enforces that <code>username</code> must be checked for emptyness.

Conditional execution on an `Option` value should be done with
`foreach`; instead of

	if (opt.isDefined)
	  operate(opt.get)

.LP write

	opt foreach { value =>
	  operate(value)
	}

The style may seem odd, but provides greater safety (we don't call the
exceptional `get`) and brevity. If both branches are taken, use
pattern matching:

	opt match {
	  case Some(value) => operate(value)
	  case None => defaultAction()
	}

.LP but if all that's missing is a default value, use <code>getOrElse</code>

	operate(opt getOrElse defaultValue)
	
Do not overuse  `Option`: if there is a sensible
default -- a [*Null Object*](http://en.wikipedia.org/wiki/Null_Object_pattern) -- use that instead.

`Option` also comes with a handy constructor for wrapping nullable values:

	Option(getClass.getResourceAsStream("foo"))
	
.LP is an <code>Option[InputStream]</code> that assumes a value of <code>None</code> should <code>getResourceAsStream</code> return <code>null</code>.

### Pattern matching

Pattern matches (`x match { ...`) are pervasive in well written Scala
code: they conflate conditional execution, destructuring, and casting
into one construct. Used well they enhance both clarity and safety.

Use pattern matching to implement type switches:

	obj match {
	  case str: String => ...
	  case addr: SocketAddress => ...

Pattern matching works best when also combined with destructuring (for
example if you are matching case classes); instead of

	animal match {
	  case dog: Dog => "dog (%s)".format(dog.breed)
	  case _ => animal.species
	  }

.LP write

	animal match {
	  case Dog(breed) => "dog (%s)".format(breed)
	  case other => other.species
	}

Write [custom extractors](http://www.scala-lang.org/node/112) but only with
a dual constructor (`apply`), otherwise their use may be out of place.

Don't use pattern matching for conditional execution when defaults
make more sense. The collections libraries usually provide methods
that return `Option`s; avoid

	val x = list match {
	  case head :: _ => head
	  case Nil => default
	}

.LP because

	val x = list.headOption getOrElse default

.LP is both shorter and communicates purpose.

### Partial functions

Scala provides syntactical shorthand for defining a `PartialFunction`:

	val pf: PartialFunction[Int, String] = {
	  case i if i%2 == 0 => "even"
	}
	
.LP and they may be composed with <code>orElse</code>

	val tf: (Int => String) = pf orElse { case _ => "odd"}
	
	tf(1) == "odd"
	tf(2) == "even"

Partial functions arise in many situations and are effectively
encoded with `PartialFunction`, for example as arguments to
methods

	trait Publisher[T] {
	  def subscribe(f: PartialFunction[T, Unit])
	}

	val publisher: Publisher[Int] = ...
	publisher.subscribe {
	  case i if isPrime(i) => println("found prime", i)
	  case i if i%2 == 0 => count += 2
	  /* ignore the rest */
	}

.LP or in situations that might otherwise call for returning an <code>Option</code>:

	// Attempt to classify the the throwable for logging.
	type Classifier = Throwable => Option[java.util.logging.Level]

.LP might be better expressed with a <code>PartialFunction</code>

	type Classifier = PartialFunction[Throwable, java.util.Logging.Level]
	
.LP as it affords greater composability:

	val classifier1: Classifier
	val classifier2: Classifier

	val classifier: Classifier = classifier1 orElse classifier2 orElse { case _ => java.util.Logging.Level.FINEST }


### Destructuring bindings

Destructuring value bindings are related to pattern matching; they use the same
mechanism but are applicable when there is exactly one option (lest you accept
the possibility of an exception). Destructuring binds are particularly useful for
tuples and case classes.

	val tuple = ('a', 1)
	val (char, digit) = tuple
	
	val tweet = Tweet("just tweeting", Time.now)
	val Tweet(text, timestamp) = tweet

### Laziness

Fields in scala are computed *by need* when `val` is prefixed with
`lazy`. Because fields and methods are equivalent in Scala (lest the fields
are `private[this]`)

	lazy val field = computation()

.LP is (roughly) short-hand for

	var _theField = None
	def field = if (_theField.isDefined) _theField.get else {
	  _theField = Some(computation())
	  _theField.get
	}

.LP i.e., it computes a results and memoizes it. Use lazy fields for this purpose, but avoid using laziness when laziness is required by semantics. In these cases it's better to be explicit since it makes the cost model explicit, and side effects can be controlled more precisely.

Lazy fields are thread safe.

### Call by name

Method parameters may be specified by-name, meaning the parameter is
bound not to a value but to a *computation* that may be repeated. This
feature must be applied with care; a caller expecting by-value
semantics will be surprised. The motivation for this feature is to
construct syntactically natural DSLs -- new control constructs in
particular can be made to look much like native language features.

Only use call-by-name for such control constructs, where it is obvious
to the caller that what is being passed in is a "block" rather than
the result of an unsuspecting computation. Only use call-by-name arguments
in the last position of the last argument list. When using call-by-name,
ensure that the method is named so that it is obvious to the caller that 
its argument is call-by-name.

When you do want a value to be computed multiple times, and especially
when this computation is side effecting, use explicit functions:

	class SSLConnector(mkEngine: () => SSLEngine)
	
.LP The intent remains obvious and the caller is left without surprises.

### `flatMap`

`flatMap` -- the combination of `map` with `flatten` -- deserves special
attention, for it has subtle power and great utility. Like its brethren `map`, it is frequently
available in nontraditional collections such as `Future` and `Option`. Its behavior
is revealed by its signature; for some `Container[A]`

	flatMap[B](f: A => Container[B]): Container[B]

.LP <code>flatMap</code> invokes the function <code>f</code> for the element(s) of the collection producing a <em>new</em> collection, (all of) which are flattened into its result. For example, to get all permutations of two character strings that aren't the same character repeated twice:

	val chars = 'a' to 'z'
	val perms = chars flatMap { a => 
	  chars flatMap { b => 
	    if (a != b) Seq("%c%c".format(a, b)) 
	    else Seq() 
	  }
	}

.LP which is equivalent to the more concise for-comprehension (which is &mdash; roughly &mdash; syntactical sugar for the above):

	val perms = for {
	  a <- chars
	  b <- chars
	  if a != b
	} yield "%c%c".format(a, b)

`flatMap` is frequently useful when dealing with `Options` -- it will
collapse chains of options down to one,

	val host: Option[String] = ...
	val port: Option[Int] = ...
	
	val addr: Option[InetSocketAddress] =
	  host flatMap { h =>
	    port map { p =>
	      new InetSocketAddress(h, p)
	    }
	  }

.LP which is also made more succinct with <code>for</code>

	val addr: Option[InetSocketAddress] = for {
	  h <- host
	  p <- port
	} yield new InetSocketAddress(h, p)

The use of `flatMap` in `Future`s is discussed in the 
<a href="#Twitter's%20standard%20libraries-Futures">futures section</a>.

## Object oriented programming

Much of Scala's vastness lies in its object system. Scala is a *pure*
language in the sense that *all values* are objects; there is no
distinction between primitive types and composite ones.
Scala also features mixins allowing for more orthogonal and piecemeal
construction of modules that can be flexibly put together at compile
time with all the benefits of static type checking.

A motivation behind the mixin system was to obviate the need for 
traditional dependency injection. The culmination of this "component
style" of programming is [the cake
pattern](http://jonasboner.com/2008/10/06/real-world-scala-dependency-injection-di/).

### Dependency injection

In our use, however, we've found that Scala itself removes so much of
the syntactical overhead of "classic" (constructor) dependency
injection that we'd rather just use that: it is clearer, the
dependencies are still encoded in the (constructor) type, and class
construction is so syntactically trivial that it becomes a breeze.
It's boring and simple and it works. *Use dependency injection for
program modularization*, and in particular, *prefer composition over
inheritance* -- for this leads to more modular and testable programs.
When encountering a situation requiring inheritance, ask yourself: how
would you structure the program if the language lacked support for
inheritance? The answer may be compelling.

Dependency injection typically makes use of traits,

	trait TweetStream {
	  def subscribe(f: Tweet => Unit)
	}
	class HosebirdStream extends TweetStream ...
	class FileStream extends TweetStream ...
	
	class TweetCounter(stream: TweetStream) {
	  stream.subscribe { tweet => count += 1 }
	}

It is common to inject *factories* -- objects that produce other
objects. In these cases, favor the use of simple functions over specialized
factory types.

	class FilteredTweetCounter(mkStream: Filter => TweetStream) {
	  mkStream(PublicTweets).subscribe { tweet => publicCount += 1 }
	  mkStream(DMs).subscribe { tweet => dmCount += 1 }
	}

### Traits

Dependency injection does not at all preclude the use of common *interfaces*, or
the implementation of common code in traits. Quite the contrary -- the use of traits are
highly encouraged for exactly this reason: multiple interfaces
(traits) may be implemented by a concrete class, and common code can
be reused across all such classes.

Keep traits short and orthogonal: don't lump separable functionality
into a trait, think of the smallest related ideas that fit together. For example,
imagine you have an something that can do IO:

	trait IOer {
	  def write(bytes: Array[Byte])
	  def read(n: Int): Array[Byte]
	}
	
.LP separate the two behaviors:

	trait Reader {
	  def read(n: Int): Array[Byte]
	}
	trait Writer {
	  def write(bytes: Array[Byte])
	}
	
.LP and mix them together to form what was an <code>IOer</code>: <code>new Reader with Writer</code>&hellip; Interface minimalism leads to greater orthogonality and cleaner modularization.

### Visibility

Scala has very expressive visibility modifiers. It's important to use
these as they define what constitutes the *public API*. Public APIs
should be limited so users don't inadvertently rely on implementation
details and limit the author's ability to change them: They are crucial
to good modularity. As a rule, it's much easier to expand public APIs
than to contract them. Poor annotations can also compromise backwards
binary compatibility of your code.

#### `private[this]`

A class member marked `private`, 

	private val x: Int = ...
	
.LP is visible to all <em>instances</em> of that class (but not their subclasses). In most cases, you want <code>private[this]</code>.

	private[this] val x: Int = ...

.LP which limits visibility to the particular instance. The Scala compiler is also able to translate <code>private[this]</code> into a simple field access (since access is limited to the statically defined class) which can sometimes aid performance optimizations.

#### Singleton class types

It's common in Scala to create singleton class types, for example

	def foo() = new Foo with Bar with Baz {
	  ...
	}

.LP In these situations, visibility can be constrained by declaring the returned type:

	def foo(): Foo with Bar = new Foo with Bar with Baz {
	  ...
	}

.LP where callers of <code>foo()</code> will see a restricted view (<code>Foo with Bar</code>) of the returned instance.

### Structural typing

Do not use structural types in normal use. They are a convenient and
powerful feature, but unfortunately do not have an efficient
implementation on the JVM. However -- due to an implementation quirk -- 
they provide a very nice shorthand for doing reflection.

	val obj: AnyRef
	obj.asInstanceOf[{def close()}].close()

## Error handling

Scala provides an exception facility, but do not use it for
commonplace errors, when the programmer must handle errors properly
for correctness. Instead, encode such errors explicitly: using
`Option` or `com.twitter.util.Try` are good, idiomatic choices, as
they harness the type system to ensure that the user is properly
considering error handling.

For example, when designing a repository, the following API may 
be tempting:

	trait Repository[Key, Value] {
	  def get(key: Key): Value
	}

.LP but this would require the implementor to throw an exception when the key is absent. A better approach is to use an <code>Option</code>:

	trait Repository[Key, Value] {
	  def get(key: Key): Option[Value]
	}

.LP This interface makes it obvious that the repository may not contain every key, and that the programmer must handle missing keys.  Furthermore, <code>Option</code> has a number of combinators to handle these cases. For example, <code>getOrElse</code> is used to supply a default value for missing keys:

	val repo: Repository[Int, String]
	repo.get(123) getOrElse "defaultString"

### Handling exceptions

Because Scala's exception mechanism isn't *checked* -- the compiler
cannot statically tell whether the programmer has covered the set of
possible exceptions -- it is often tempting to cast a wide net when
handling exceptions.

However, some exceptions are *fatal* and should never be caught; the
code

	try {
	  operation()
	} catch {
	  case _ => ...
	}

.LP is almost always wrong, as it would catch fatal errors that need to be propagated. Instead, use the <code>com.twitter.util.NonFatal</code> extractor to handle only nonfatal exceptions.

	try {
	  operation()
	} catch {
	  case NonFatal(exc) => ...
	}

## Garbage collection

We spend a lot of time tuning garbage collection in production. The
garbage collection concerns are largely similar to those of Java
though idiomatic Scala code tends to generate more (short-lived)
garbage than idiomatic Java code -- a byproduct of the functional
style. Hotspot's generational garbage collection typically makes this
a nonissue as short-lived garbage is effectively free in most circumstances.

Before tackling GC performance issues, watch
[this](http://www.infoq.com/presentations/JVM-Performance-Tuning-twitter)
presentation by Attila that illustrates some of our experiences with
GC tuning.

In Scala proper, your only tool to mitigate GC problems is to generate
less garbage; but do not act without data! Unless you are doing
something obviously degenerate, use the various Java profiling tools
-- our own include
[heapster](https://github.com/mariusaeriksen/heapster) and
[gcprof](https://github.com/twitter/jvmgcprof).

## Java compatibility

When we write code in Scala that is used from Java, we ensure
that usage from Java remains idiomatic. Oftentimes this requires
no extra effort -- classes and pure traits are exactly equivalent
to their Java counterpart -- but sometimes separate Java APIs
need to be provided. A good way to get a feel for your library's Java
API is to write a unittest in Java (just for compilation); this also ensures
that the Java-view of your library remains stable over time as the Scala
compiler can be volatile in this regard.

Traits that contain implementation are not directly
usable from Java: extend an abstract class with the trait
instead.

	// Not directly usable from Java
	trait Animal {
	  def eat(other: Animal)
	  def eatMany(animals: Seq[Animal) = animals foreach(eat(_))
	}
	
	// But this is:
	abstract class JavaAnimal extends Animal

## Twitter's standard libraries

The most important standard libraries at Twitter are
[Util](http://github.com/twitter/util) and
[Finagle](https://github.com/twitter/finagle). Util should be
considered an extension to the Scala and Java standard libraries, 
providing missing functionality or more appropriate implementations. Finagle
is our RPC system; the kernel distributed systems components.

### Futures

Futures have been <a href="#Concurrency-Futures">discussed</a>
briefly in the <a href="#Concurrency">concurrency section</a>. They 
are the central mechanism for coordination asynchronous
processes and are pervasive in our codebase and core to Finagle.
Futures allow for the composition of concurrent events, and simplify
reasoning about highly concurrent operations. They also lend themselves
to a highly efficient implementation on the JVM.

Twitter's futures are *asynchronous*, so blocking operations --
basically any operation that can suspend the execution of its thread;
network IO and disk IO are examples -- must be handled by a system
that itself provides futures for the results of said operations.
Finagle provides such a system for network IO.

Futures are plain and simple: they hold the *promise* for the result
of a computation that is not yet complete. They are a simple container
-- a placeholder. A computation could fail of course, and this must 
also be encoded: a Future can be in exactly one of 3 states: *pending*,
*failed* or *completed*.

<div class="explainer">
<h3>Aside: <em>Composition</em></h3>
<p>Let's revisit what we mean by composition: combining simpler components
into more complicated ones. The canonical example of this is function
composition: Given functions <em>f</em> and
<em>g</em>, the composite function <em>(g&#8728;f)(x) = g(f(x))</em> &mdash; the result
of applying <em>f</em> to <em>x</em> first, and then applying <em>g</em> to the result
of that &mdash; can be written in Scala:</p>

<pre><code>val f = (i: Int) => i.toString
val g = (s: String) => s+s+s
val h = g compose f  // : Int => String
	
scala> h(123)
res0: java.lang.String = 123123123</code></pre>

.LP the function <em>h</em> being the composite. It is a <em>new</em> function that combines both <em>f</em> and <em>g</em> in a predefined way.
</div>

Futures are a type of collection -- they are a container of
either 0 or 1 elements -- and you'll find they have standard 
collection methods (eg. `map`, `filter`, and `foreach`). Since a Future's
value is deferred, the result of applying any of these methods
is necessarily also deferred; in

	val result: Future[Int]
	val resultStr: Future[String] = result map { i => i.toString }

.LP the function <code>{ i => i.toString }</code> is not invoked until the integer value becomes available, and the transformed collection <code>resultStr</code> is also in pending state until that time.

Lists can be flattened;

	val listOfList: List[List[Int]] = ...
	val list: List[Int] = listOfList.flatten

.LP and this makes sense for futures, too:

	val futureOfFuture: Future[Future[Int]] = ...
	val future: Future[Int] = futureOfFuture.flatten

.LP since futures are deferred, the implementation of <code>flatten</code> &mdash; it returns immediately &mdash; has to return a future that is the result of waiting for the completion of the outer future (<code><b>Future[</b>Future[Int]<b>]</b></code>) and after that the inner one (<code>Future[<b>Future[Int]</b>]</code>). If the outer future fails, the flattened future must also fail.

Futures (like Lists) also define `flatMap`; `Future[A]` defines its signature as

	flatMap[B](f: A => Future[B]): Future[B]
	
.LP which is like the combination of both <code>map</code> and <code>flatten</code>, and we could implement it that way:

	def flatMap[B](f: A => Future[B]): Future[B] = {
	  val mapped: Future[Future[B]] = this map f
	  val flattened: Future[B] = mapped.flatten
	  flattened
	}

This is a powerful combination! With `flatMap` we can define a Future that
is the result of two futures sequenced, the second future computed based
on the result of the first one. Imagine we needed to do two RPCs in order
to authenticate a user (id), we could define the composite operation in the
following way:

	def getUser(id: Int): Future[User]
	def authenticate(user: User): Future[Boolean]
	
	def isIdAuthed(id: Int): Future[Boolean] = 
	  getUser(id) flatMap { user => authenticate(user) }

.LP an additional benefit to this type of composition is that error handling is built-in: the future returned from <code>isAuthed(..)</code> will fail if either of <code>getUser(..)</code> or <code>authenticate(..)</code> does with no extra error handling code.

#### Style

Future callback methods (`respond`, `onSuccess`, `onFailure`, `ensure`)
return a new future that is *chained* to its parent. This future is guaranteed
to be completed only after its parent, enabling patterns like

	acquireResource() onSuccess { value =>
	  computeSomething(value)
	} ensure {
	  freeResource()
	}

.LP where <code>freeResource()</code> is guaranteed to be executed only after <code>computeSomething</code>, allowing for emulation of the native <code>try .. finally</code> pattern.

Use `onSuccess` instead of `foreach` -- it is symmetrical to `onFailure` and
is a better name for the purpose, and also allows for chaining.

Always try to avoid creating `Promise` instances directly: nearly every task
can be accomplished via the use of predefined combinators. These
combinators ensure errors and cancellations are propagated, and generally
encourage *dataflow style* programming which usually <a
href="#Concurrency-Futures">obviates the need for synchronization and
volatility declarations</a>.

Code written in tail-recursive style is not subject to stack-space leaks,
allowing for efficient implementation of loops in dataflow-style:

	case class Node(parent: Option[Node], ...)
	def getNode(id: Int): Future[Node] = ...

	def getHierarchy(id: Int, nodes: List[Node] = Nil): Future[Node] =
	  getNode(id) flatMap {
	    case n@Node(Some(parent), ..) => getHierarchy(parent, n :: nodes)
	    case n => Future.value((n :: nodes).reverse)
	  }

`Future` defines many useful methods: Use `Future.value()` and
`Future.exception()` to create pre-satisfied futures.
`Future.collect()`, `Future.join()` and `Future.select()` provide
combinators that turn many futures into one (ie. the gather part of a
scatter-gather operation).

#### Cancellation

Futures implement a weak form of cancellation. Invoking `Future#cancel`
does not directly terminate the computation but instead propagates a
level triggered *signal* that may be queried by whichever process
ultimately satisfies the future. Cancellation flows in the opposite
direction from values: a cancellation signal set by a consumer is
propagated to its producer. The producer uses `onCancellation` on
`Promise` to listen to this signal and act accordingly.

This means that the cancellation semantics depend on the producer,
and there is no default implementation. *Cancellation is but a hint*.

#### Locals

Util's
[`Local`](https://github.com/twitter/util/blob/master/util-core/src/main/scala/com/twitter/util/Local.scala#L40)
provides a reference cell that is local to a particular future dispatch tree. Setting the value of a local makes this
value available to any computation deferred by a Future in the same thread. They are analogous to thread locals,
except their scope is not a Java thread but a tree of "future threads". In

	trait User {
	  def name: String
	  def incrCost(points: Int)
	}
	val user = new Local[User]

	...

	user() = currentUser
	rpc() ensure {
	  user().incrCost(10)
	}

.LP <code>user()</code> in the <code>ensure</code> block will refer to the value of the <code>user</code> local at the time the callback was added.

As with thread locals, `Local`s can be very convenient, but should
almost always be avoided: make sure the problem cannot be sufficiently
solved by passing data around explicitly, even if it is somewhat
burdensome.

Locals are used effectively by core libraries for *very* common 
concerns -- threading through RPC traces, propagating monitors,
creating "stack traces" for future callbacks -- where any other solution
would unduly burden the user. Locals are inappropriate in almost any
other situation.

### Offer/Broker

Concurrent systems are greatly complicated by the need to coordinate
access to shared data and resources.
[Actors](http://doc.akka.io/api/akka/current/index.html#akka.actor.Actor)
present one strategy of simplification: each actor is a sequential process
that maintains its own state and resources, and data is shared by
messaging with other actors. Sharing data requires communicating between
actors.

Offer/Broker builds on this in three important ways. First,
communication channels (Brokers) are first class -- that is, you send
messages via Brokers, not to an actor directly. Secondly, Offer/Broker
is a synchronous mechanism: to communicate is to synchronize. This
means we can use Brokers as a coordination mechanism: when process `a`
has sent a message to process `b`; both `a` and `b` agree on the state
of the system. Lastly, communication can be performed *selectively*: a
process can propose several different communications, and exactly one
of them will obtain.

In order to support selective communication (as well as other
composition) in a general way, we need to decouple the description of
a communication from the act of communicating. This is what an `Offer`
does -- it is a persistent value that describes a communication; in
order to perform that communication (act on the offer), we synchronize
via its `sync()` method

	trait Offer[T] {
	  def sync(): Future[T]
	}

.LP which returns a <code>Future[T]</code> that yields the exchanged value when the communication obtains.

A `Broker` coordinates the exchange of values through offers -- it is the channel of communications:

	trait Broker[T] {
	  def send(msg: T): Offer[Unit]
	  val recv: Offer[T]
	}

.LP so that, when creating two offers

	val b: Broker[Int]
	val sendOf = b.send(1)
	val recvOf = b.recv

.LP and <code>sendOf</code> and <code>recvOf</code> are both synchronized

	// In process 1:
	sendOf.sync()

	// In process 2:
	recvOf.sync()

.LP both offers obtain and the value <code>1</code> is exchanged.

Selective communication is performed by combining several offers with
`Offer.choose`

	def choose[T](ofs: Offer[T]*): Offer[T]

.LP which yields a new offer that, when synchronized, obtains exactly one of <code>ofs</code> &mdash; the first one to become available. When several are available immediately, one is chosen at random to obtain.

The `Offer` object has a number of one-off Offers that are used to compose with Offers from a Broker.

	Offer.timeout(duration): Offer[Unit]

.LP is an offer that activates after the given duration. <code>Offer.never</code> will never obtain, and <code>Offer.const(value)</code> obtains immediately with the given value. These are useful for composition via selective communication. For example to apply a timeout on a send operation:

	Offer.choose(
	  Offer.timeout(10.seconds),
	  broker.send("my value")
	).sync()

It may be tempting to compare the use of Offer/Broker to
[SynchronousQueue](http://docs.oracle.com/javase/6/docs/api/java/util/concurrent/SynchronousQueue.html),
but they are different in subtle but important ways. Offers can be composed in ways that such queues simply cannot. For example, consider a set of queues, represented as Brokers:

	val q0 = new Broker[Int]
	val q1 = new Broker[Int]
	val q2 = new Broker[Int]
	
.LP Now let's create a merged queue for reading:

	val anyq: Offer[Int] = Offer.choose(q0.recv, q1.recv, q2.recv)
	
.LP <code>anyq</code> is an offer that will read from first available queue. Note that <code>anyq</code> is <em>still synchronous</em> &mdash; we still have the semantics of the underlying queues. Such composition is simply not possible using queues.
	
#### Example: A Simple Connection Pool

Connection pools are common in network applications, and they're often
tricky to implement -- for example, it's often desirable to have
timeouts on acquisition from the pool since various clients have different latency
requirements. Pools are simple in principle: we maintain a queue of
connections, and we satisfy waiters as they come in. With traditional
synchronization primitives this typically involves keeping two queues:
one of waiters (when there are no connections), and one of connections
(when there are no waiters).

Using Offer/Brokers, we can express this quite naturally:

	class Pool(conns: Seq[Conn]) {
	  private[this] val waiters = new Broker[Conn]
	  private[this] val returnConn = new Broker[Conn]

	  val get: Offer[Conn] = waiters.recv
	  def put(c: Conn) { returnConn ! c }
	
	  private[this] def loop(connq: Queue[Conn]) {
	    Offer.choose(
	      if (connq.isEmpty) Offer.never else {
	        val (head, rest) = connq.dequeue()
	        waiters.send(head) map { _ => loop(rest) }
	      },
	      returnConn.recv map { c => loop(connq.enqueue(c)) }
	    ).sync()
	  }
	
	  loop(Queue.empty ++ conns)
	}

`loop` will always offer to have a connection returned, but only offer
to send one when the queue is nonempty. Using a persistent queue simplifies
reasoning further. The interface to the pool is also through an Offer, so if a caller
wishes to apply a timeout, they can do so through the use of combinators:

	val conn: Future[Option[Conn]] = Offer.choose(
	  pool.get map { conn => Some(conn) },
	  Offer.timeout(1.second) map { _ => None }
	).sync()

No extra bookkeeping was required to implement timeouts; this is due to
the semantics of Offers: if `Offer.timeout` is selected, there is no
longer an offer to receive from the pool -- the pool and its caller
never simultaneously agreed to receive and send, respectively, on the
`waiters` broker.

#### Example: Sieve of Eratosthenes

It is often useful -- and sometimes vastly simplifying -- to structure
concurrent programs as a set of sequential processes that communicate
synchronously. Offers and Brokers provide a set of tools to make this simple
and uniform. Indeed, their application transcends what one might think
of as "classic" concurrency problems -- concurrent programming (with
the aid of Offer/Broker) is a useful *structuring* tool, just as
subroutines, classes, and modules are -- another important 
idea from CSP.

One example of this is the [Sieve of
Eratosthenes](http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes),
which can be structured as a successive application of filters to a
stream of integers. First, we'll need a source of integers:

	def integers(from: Int): Offer[Int] = {
	  val b = new Broker[Int]
	  def gen(n: Int): Unit = b.send(n).sync() ensure gen(n + 1)
	  gen(from)
	  b.recv
	}

.LP <code>integers(n)</code> is simply the offer of all consecutive integers starting at <code>n</code>. Then we need a filter:

	def filter(in: Offer[Int], prime: Int): Offer[Int] = {
	  val b = new Broker[Int]
	  def loop() {
	    in.sync() onSuccess { i =>
	      if (i % prime != 0)
	        b.send(i).sync() ensure loop()
	      else
	        loop()
	    }
	  }
	  loop()
	
	  b.recv
	}

.LP <code>filter(in, p)</code> returns the offer that removes multiples of the prime <code>p</code> from <code>in</code>. Finally, we define our sieve:

	def sieve = {
	  val b = new Broker[Int]
	  def loop(of: Offer[Int]) {
	    for (prime <- of.sync(); _ <- b.send(prime).sync())
	      loop(filter(of, prime))
	  }
	  loop(integers(2))
	  b.recv
	}

.LP <code>loop()</code> works simply: it reads the next (prime) number from <code>of</code>, and then applies a filter to <code>of</code> that excludes this prime. As <code>loop</code> recurses, successive primes are filtered, and we have a Sieve. We can now print out the first 10000 primes:

	val primes = sieve
	0 until 10000 foreach { _ =>
	  println(primes.sync()())
	}

Besides being structured into simple, orthogonal components, this
approach gives you a streaming Sieve: you do not a priori need to
compute the set of primes you are interested in, further enhancing
modularity.

## Acknowledgments

The lessons herein are those of Twitter's Scala community -- I hope
I've been a faithful chronicler.

Blake Matheny, Nick Kallen, Steve Gury, and Raghavendra Prabhu
provided much helpful guidance and many excellent suggestions.

[Scala]: http://www.scala-lang.org/
[Finagle]: http://github.com/twitter/finagle
[Util]: http://github.com/twitter/util
