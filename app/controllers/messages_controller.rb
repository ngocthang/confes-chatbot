class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:create, :new]
  before_action :load_new_msg

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all.order(id: :desc).page(params[:page]).per(20)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    if @message.save
      flash[:success] = 'Message was successfully created.'
      redirect_to new_message_path
    else
      render :new
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    res = @message.post_msg
    if res.code == "200"
      flash[:success] = "Confession approved !"
      @message.update status: 1
    end
    redirect_to messages_path
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:content, :status)
  end

  def load_new_msg
    @count_new_msg = Message.where(status: 0).count
  end
end
