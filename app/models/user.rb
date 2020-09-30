class User < ApplicationRecord
    validates :kanjiName, presence: { message: "必須入力が漏れています、内容を確認してください" }
    # validates_format_of :kanjiName, with: /[a-zA-Z0-9]/, on: :create
    # validates_format_of :kanjiName, with: /[\x3400-\x4DB5\x4E00-\x9FCB\xF900-\xFA6A]+/, on: :create
    validates_format_of :kanjiName, with: /[\u4E00-\u9FAF]/, on: :create
    
    validates :kanaName, presence: { message: "必須入力が漏れています、内容を確認してください" }
    validates_format_of :kanaName, with: /[\u3040-\u309F]|[\u30A0-\u30FF]/, on: :create

    validates :dateOfBirth, presence: { message: "必須入力が漏れています、内容を確認してください" }
    validates :birthPlace, exclusion: { in: ['出身地選択'], message: "必須入力が漏れています、内容を確認してください" }
    # validates :height, numericality: true
    # validates :weight, numericality: true
    # validates :score, numericality: { only_integer: true }
    
    has_one_attached :image

end
