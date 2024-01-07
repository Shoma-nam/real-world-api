class ArticlesController < ApplicationController
    def index
        articles = Article.all
        render json: articles
    end
    def create
      article = Article.new(article_params.except(:tagList))
      if article.save
        handle_tag_list(article, article_params[:tagList])
        render json: { article: article }, status: :created
      else
        render json: { errors: article.errors }, status: :unprocessable_entity
      end
    end
  
    private
  
    def article_params
      params.require(:article).permit(:title, :description, :body, tagList: [])
    end
  
    def handle_tag_list(article, tag_list)
      return if tag_list.blank?
  
      tag_list.each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        article.tags << tag unless article.tags.include?(tag)
      end
    end
end

