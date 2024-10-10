# private-saas-with-aws-privatelink-vpn
This repository is the example for network infrastructure of connection between medical facilities and AWS environment.


## Note 
下記のように環境変数を設定しないと、M1 Mac などでは動かなかった。（private-saas 配下）
```sh
export GODEBUG=asyncpreemptoff=1;
```


https での通信をしたいので、ドメインを事前に購入する必要あり。（本当に？）  
external ALB の場合は事前に必要なので、private ALB の場合は事前に必要なのかは不明。  
