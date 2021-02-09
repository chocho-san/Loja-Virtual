String getErrorString(String code){
  switch (code) {
    case 'ERROR_WEAK_PASSWORD':
      return 'パスワードの安全性が低いです。';
    case 'ERROR_INVALID_EMAIL':
      return 'このメールアドレスは無効になっています。';
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return '既アカウントで使われているメアドです。';
    case 'ERROR_INVALID_CREDENTIAL':
      return '無効なパスワードです';
    case 'ERROR_WRONG_PASSWORD':
      return 'パスワードが間違っています。';
    case 'ERROR_USER_NOT_FOUND':
      return 'このアカウントは存在しません。';
    case 'ERROR_USER_DISABLED':
      return 'このユーザーは無効です。';
    case 'ERROR_TOO_MANY_REQUESTS':
      return '回線が混雑しています。もう一度試してみてください。';
    case 'ERROR_OPERATION_NOT_ALLOWED':
      return 'この操作はできません。';

    default:
      return '予期せぬエラーが発生しました。';
  }
}