# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::ItemsController do

  describe '#list' do

    context 'アイテムの購入履歴がある場合' do
      it '購入したアイテムのリストが返ること' 
    end

  end

  describe '#purchase' do

    context 'レシートのidのアイテムが存在しない場合' do
      context '正常なレシートの場合' do
        it 'アイテムが作成されること' 
        it 'アイテムに応じたポイント追加などの操作が行われること' 
        it 'okが返ること' 
      end

      context '異常なレシートの場合' do
        it 'サーバーエラーが返ること' 
      end
    end

    context 'レシートのidのアイテムが既に存在する場合' do
      it 'サーバーエラーが返ること' 
    end

  end

end