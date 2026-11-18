# VARIABLE RUNNERS DEVELOPMENT HUB — 公開スターターキット

## 現在の内容
- PC / iPhone対応の淡色UI
- ダッシュボード
- 素材ライブラリ（登録・検索・詳細・編集・削除）
- タスク管理（登録・検索条件・編集・削除）
- 設定資料集（分類・検索・編集・削除）
- 更新履歴
- SupabaseクラウドDB接続
- 完全公開方式（ログイン・合言葉なし）

## 重要：完全公開の仕様
この構成では、サイトURLを知る人は誰でもデータの閲覧・追加・編集・削除ができます。
匿名利用のため、操作した人の個人特定はできません。荒らし・誤削除・スパムのリスクがあります。
本番利用前に十分理解したうえで公開してください。公開前の重要データは入れないでください。

## 1. Supabaseを準備
1. https://supabase.com/ でプロジェクトを作成
2. Project Settings → API から Project URL と anon / publishable key を控える
3. SQL Editorを開き、同梱の `supabase.sql` 全文を貼り付けてRun
4. 同梱の `config.js` にはProject URLとPublishable keyを設定済みです（必要ならSupabaseのConnect画面からURLを再確認してください）

**絶対に service_role key を config.js に入力しないでください。** anon / publishable key は公開用キーですが、今回のDBポリシーは意図的に全員へ全権限を与えています。

## 2. Vercelへ公開
1. https://github.com/new で `variable-runners-development-hub` というリポジトリを作成
2. このフォルダ内の `index.html` と `config.js` をアップロードしてCommit
3. `supabase.sql` と `README.md` も保管用にアップロードしておく
4. https://vercel.com/new でGitHubリポジトリをImport
5. Framework PresetはOther、Build Commandは空欄、Output Directoryは `.` のままDeploy
6. 発行された `https://....vercel.app` がサイトURL。PCとiPhoneで同じURLを開けます。

## 3. 更新方法
GitHubで `index.html` または `config.js` を更新してCommitすると、Vercelが自動で再公開します。

## 現在の制限
- 素材ファイル欄はファイルURLの登録方式です。ファイル本体のアップロードUIは次の開発段階で追加が必要です（Supabase StorageバケットはSQLで準備します）。
- カテゴリーは現状、標準の大分類を選択する方式です。階層カテゴリーの自由な追加・編集は次段階で実装します。
- 更新履歴は操作内容と時刻を記録しますが、ユーザー個人は識別しません。
- バックアップはSupabase側のバックアップ/エクスポートも併用してください。
- インターネットに公開するため、秘密情報・個人情報・公開したくない未発表資料は保存しないでください。
