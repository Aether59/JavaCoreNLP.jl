
#edu.stanford.nlp.pipeline.Annotation===========================================
JAnnotation = @jimport edu.stanford.nlp.pipeline.Annotation
JSentencesAnnotationClass = classforname("edu.stanford.nlp.ling.CoreAnnotations\$SentencesAnnotation")
JTokensAnnotationClass = classforname("edu.stanford.nlp.ling.CoreAnnotations\$TokensAnnotation")
JTreeAnnotationClass = classforname("edu.stanford.nlp.trees.TreeCoreAnnotations\$TreeAnnotation")
JCollapsedCCProcessedDependenciesAnnotationClass = classforname("edu.stanford.nlp.semgraph.SemanticGraphCoreAnnotations\$CollapsedCCProcessedDependenciesAnnotation")

##Wrapper
type Annotation
    jann::JAnnotation
end

Base.show(io::IO, ann::Annotation) = print(io, "Annotation(...)")  # TODO: make more meaningful show

##Constructor
function Annotation(text::AbstractString)
    jann = JAnnotation((JString,), text)
    return Annotation(jann)
end

##Returns iterable list of annotated sentences in an Annotation.
function Sentences(doc::Annotation)
    return narrow(jcall(doc.jann, "get", JObject, (JClass,), JSentencesAnnotationClass))
end

##Returns iterable list of tokens in an annotated sentence.
function Tokens(sentence::JAnnotation)
    return narrow(jcall(sentence, "get", JObject, (JClass,), JTokensAnnotationClass))
end

##Returns the syntactic parse tree of a sentence.
function Tree(sentence::JAnnotation)
    return narrow(jcall(sentence, "get", JObject, (JClass,), JTreeAnnotationClass))
end

##Returns the syntactic dependencies of a sentence.
function Semgraph(sentence::JAnnotation)
    return narrow(jcall(sentence, "get", JObject, (JClass,), JCollapsedCCProcessedDependenciesAnnotationClass))
end
#==============================================================================#


#edu.stanford.nlp.pipeline.StanfordCoreNLP======================================
JStanfordCoreNLP = @jimport edu.stanford.nlp.pipeline.StanfordCoreNLP

##Wrapper
type StanfordCoreNLP
    jpipeline::JStanfordCoreNLP
end

Base.show(io::IO, pipeline::StanfordCoreNLP) = print(io, "StanfordCoreNLP(...)")

##Constructor
function StanfordCoreNLP(props::Dict{String, String})
    jprops = to_jprops(props)
    jpipeline = JStanfordCoreNLP((JProperties,), jprops)
    return StanfordCoreNLP(jpipeline)
end
#==============================================================================#


#edu.stanford.nlp.ling.CoreLabel================================================
JCoreLabel = @jimport edu.stanford.nlp.ling.CoreLabel

##Returns the lemma value of the label (or null if none).
function Lemma(token::JCoreLabel)
    return jcall(token, "lemma", JString, ())
end

##Returns the tag value of the label (or null if none).
function Tag(token::JCoreLabel)
    return jcall(token, "tag", JString, ())
end

##Returns the named entity class of the label (or null if none).
function NER(token::JCoreLabel)
    return jcall(token, "ner", JString, ())
end

##Return the String which is the original character sequence of the token.
function OriginalText(token::JCoreLabel)
    return jcall(token, "originalText", JString, ())
end

##Return the word value of the label (or null if none).
function Word(token::JCoreLabel)
    return jcall(token, "word", JString, ())
end

##Prints a full dump of a CoreMap.
function CoreMapToString(token::JCoreLabel)
    return jcall(token, "toString", JString, ())
end

##Not implemented. See CoreLabelTokenFactory(boolean addIndices) to add this.
function Index(token::JCoreLabel)
    return jcall(token, "index", JString, ())
end

##Returns a String representation of just the "main" value of this label.
function Value(token::JCoreLabel)
    return jcall(token, "value", JString, ())
end
#==============================================================================#


#edu.stanford.nlp.trees.Tree====================================================

JTree = @jimport edu.stanford.nlp.trees.Tree

##Converts parse tree to string in Penn Treebank format.
function treeToString(tree::JTree)
    return jcall(tree, "toString", JString, ())
end

##Returns the number of nodes the tree contains.
function size(tree::JTree)
    return jcall(tree, "size", JString, ())
end

##Finds the depth of the tree.
function depth(tree::JTree)
    return jcall(tree, "depth", JString, ())
end

##Returns an array of children for the current node.
function children(tree::JTree)
    return jcall(tree, "children", JString, ())
end

##Returns the Constituents generated by the parse tree.
function constituents(tree::JTree)
    return jcall(tree, "constituents", JString, ())
end

##Returns an iterator over all the nodes of the tree.
function iterator(tree::JTree)
    return jcall(tree, "iterator", JString, ())
end
#==============================================================================#


#edu.stanford.nlp.tagger.maxent.MaxentTagger====================================
JArrayList = @jimport java.util.ArrayList
JList = @jimport java.util.List
JHasWord = @jimport edu.stanford.nlp.ling.HasWord
JMaxentTagger = @jimport edu.stanford.nlp.tagger.maxent.MaxentTagger

type MaxentTagger
    jmet::JMaxentTagger
end

##Path is the location of parameter files for a trained tagger.
function MaxentTagger(path::AbstractString)
    jmet = JMaxentTagger((JString,), path)
    return MaxentTagger(jmet)
end

##To tag a list of sentences and get back a list of tagged sentences:
function MaxentTagger(tagger::MaxentTagger, sentences)
    return narrow(jcall(tagger, "process", JObject, (JArrayList,), sentences)) #JObject -> JArrayList?
end

##List<TaggedWord> tagged = tagger.tagSentence(sentence)
function tagSentence(tagger::MaxentTagger, sentence::JList)
    jcall(tagger.jmet, "tagSentence", JList, (JList,), sentence)
end

#function numTags(tagger::MaxentTagger, sentence::JList)
#    jcall(tagger.jmet, "numTags", jint, (JList,), sentence)
#end

#==============================================================================#


#edu.stanford.nlp.ling.TaggedWord===============================================
JTaggedWord = @jimport edu.stanford.nlp.ling.TaggedWord

function tag(taggedword::JTaggedWord)
    return jcall(taggedword, "tag", JString, ())
end

function word(taggedword::JTaggedWord)
    return jcall(taggedword, "word", JString, ())
end

#==============================================================================#


#java.io.StringReader===========================================================
JStringReader = @jimport java.io.StringReader

type StringReader
    jsr::JStringReader
end

function StringReader(text::AbstractString)
    jsr = JStringReader((JString,), text)
    return StringReader(jsr)
end

function readStringReader(jsr::JStringReader)
    return jcall(jsr, "read", jint, (),)
end


#==============================================================================#


#edu.stanford.nlp.parser.nndep.DependencyParser=================================

JDependencyParser = @jimport edu.stanford.nlp.parser.nndep.DependencyParser
JGrammaticalStructure = @jimport edu.stanford.nlp.trees.GrammaticalStructure
JCollection = @jimport java.util.Collection

#DependencyParser parser = DependencyParser.loadFromModelFile(modelPath);
function DependencyParser(modelPath::AbstractString)
    return narrow(jcall(JDependencyParser, "loadFromModelFile", JDependencyParser, (JString,), modelPath))
end

#GrammaticalStructure gs = parser.predict(tagged);
function predict(parser::JDependencyParser , tagged::JList)
    jcall(parser, "predict", JGrammaticalStructure, (JList,), tagged)
end

function GrammaticalStructureToString(gs::JGrammaticalStructure)
    return jcall(gs, "toString", JString, ())
end


#==============================================================================#


#edu.stanford.nlp.process.DocumentPreprocessor==================================

JDocumentPreprocessor = @jimport edu.stanford.nlp.process.DocumentPreprocessor
JReader = @jimport java.io.Reader

type DocumentPreprocessor
    jdp::JDocumentPreprocessor
end

function DocumentPreprocessor(stringreader::StringReader)
    jdp = JDocumentPreprocessor((JReader,), stringreader.jsr)
    return DocumentPreprocessor(jdp)
end
#==============================================================================#


#edu.stanford.nlp.trees.GrammaticalStructure====================================

#==============================================================================#



#edu.stanford.nlp.ling.TaggedWord===============================================
JTaggedWord = @jimport edu.stanford.nlp.ling.TaggedWord

#==============================================================================#
