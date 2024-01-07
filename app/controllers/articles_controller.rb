class ArticlesController < ApplicationController
    def index
        articles = Article.all
        render json: articles
    end
    def create
        article = Article.new(article_params)
        if article.save
            render json: { article: article }, status: :created
        else
            render json: { errors: article.errors }, status: :unprocessable_entity
        end
    end
    private
    def article_params
        params.require(:article).permit(:title, :description, :body, tagList: [])
    end
    end
end
