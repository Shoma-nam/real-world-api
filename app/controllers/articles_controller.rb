class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  # 全ての記事を取得
  def index
    articles = Article.all
    render json: articles
  end

  # GET /articles/:slug
  # 特定の記事をスラグを使って取得
  def show
    if @article
      render json: { article: @article }
    else
      render json: { error: 'Article not found' }, status: :not_found
    end
  end

  # POST /articles
  # 新しい記事を作成
  def create
    article = Article.new(article_params.except(:tagList))

    if article.save
      handle_tag_list(article, article_params[:tagList]) # タグの処理
      render json: { article: article.reload }, status: :created # 作成された記事を再読み込みしてレスポンスに含める
    else
      render json: { errors: article.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/:slug
  # 記事を更新
  def update
    if @article.update(article_params)
      @article.save
      render json: { article: @article.reload }
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /articles/:slug
  # 記事を削除
  def destroy
    if @article
      @article.destroy
      head :no_content
    else
      render json: { error: 'Article not found' }, status: :not_found
    end
  end

  private

  # アクションの前に記事を設定
  def set_article
    @article = Article.find_by(slug: params[:slug])
  end

  # 許可されたパラメータのリスト
  def article_params
    params.require(:article).permit(:title, :description, :body, tagList: [])
  end

  # タグリストの処理
  def handle_tag_list(article, tag_list)
    return if tag_list.blank?

    tag_list.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      article.tags << tag unless article.tags.include?(tag)
    end
  end
end
