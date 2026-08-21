"""Módulo para gestionar el motor RAG y recuperar contexto profesional de APSARA."""

import os
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter


class RAGEngine:
    """Clase encargada de cargar la documentación corporativa y buscar contexto relevante."""

    def __init__(self, data_path: str = "./data", persist_dir: str = "./chroma_db") -> None:
        self.data_path = data_path
        self.persist_dir = persist_dir
        self.embeddings = OpenAIEmbeddings()
        self.vectorstore = self._initialize_vectorstore()

    def _initialize_vectorstore(self) -> Chroma:
        """Inicializa o carga la base de datos vectorial local con Chroma."""
        if os.path.exists(self.persist_dir):
            return Chroma(
                persist_directory=self.persist_dir,
                embedding_function=self.embeddings,
            )

        documents = []
        for file in os.listdir(self.data_path):
            if file.endswith(".pdf"):
                loader = PyPDFLoader(os.path.join(self.data_path, file))
                documents.extend(loader.load())

        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=1000, chunk_overlap=100
        )
        docs = text_splitter.split_documents(documents)

        return Chroma.from_documents(
            docs, self.embeddings, persist_directory=self.persist_dir
        )

    def query(self, question: str) -> str:
        """Busca y retorna los fragmentos más relevantes para la consulta del cliente."""
        retriever = self.vectorstore.as_retriever(search_kwargs={"k": 3})
        docs = retriever.invoke(question)
        return "\n".join([d.page_content for d in docs])
