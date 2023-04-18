## ✨ 프로젝트 소개

### 고가용성 글로벌 팬사이트 <br>

 시나리오는 아이돌 팬사이트가 글로벌 트래픽이 증가했을 때 순간적으로 급증하는 트래픽에 대응하고 빠르게 인프라를 구성, <br>
 무중단으로 웹서버를 배포하여 사용자가 서비스를 이용할 때 발생하는 다운타임을 최소화하는 시나리오입니다.
<br>


- **[발표 자료](https://docs.google.com/presentation/d/13tJ_gnHv7RO3KuGKWGPG14OrM1K35mICUmn3lk0w_ic/edit?usp=sharing)<br>**

<br>

## 📆 프로젝트 기간 <br>

<ul>
  <li>개발 기간: 2023/03/07 ~ 2023/03/24</li>
  <li>추가 업데이트: 2023/03/24 ~ 진행 중</li>
</ul>


<br>

## 📖 서비스 아키텍쳐<br>

![image](https://user-images.githubusercontent.com/87158339/227396620-02a8d8b4-6ffc-4a00-8d0e-5b505998d3ca.png)

<br>
<br>

## 🏞️ 아키텍쳐 도입 배경<br>
<details> 
  <summary><strong>1️⃣ Git Action</strong></summary><br>
  backend CI/CD 구현부로 github action을 이용하였으며 소스 리포지토리에 tag가 푸시되면 트리거됩니다. tag는 시맨틱 버전 규칙에 따라 작성하기로 약속했고 ECR 이미지 이름은 해당 tag의 이름으로 저장됩니다. 저장된 ECR 이미지는 새로운 TaskDefinition 개정을 생성하는데 사용되고 최종적으로 ECS Service가 새 개정을 참조하여 업데이트됩니다.<br>
<br>
</details>

<details> 
  <summary><strong>2️⃣ ECS 클러스터 </strong></summary><br>
  api 서버가 구현되는 환경으로 ecs는 Multi AZ 기능과 auto scaling을 통한 높은 확장성 그리고 다른 컨테이너 오케스트레이션에 비해 간단한 구성과 운영이 가능하기 때문에 저희 서비스에 최적의 도구라고 생각하여 선택하게 되었습니다. 또한 Secret Manager를 통해 DB 엔드포인트에 대한 민감 정보를 암호화하여 저장하고 ECS Taskdefinition에서 평문 Value가 아닌 Value From으로 참조가 가능합니다.<br>
<br>
</details>
<details> 
  <summary><strong>3️⃣ Aurora RDS</strong></summary><br>
  aurora는 스토리지 클러스터를 통한 스토리지 자동확장과 데이터 무결성을 보장하고 읽기 성능을 올렸으며, 쓰기 단순화를 통해 일반 RDS보다 쓰기 성능도 증가하였습니다. 무엇보다 자체적으로 autoscaling policy를 통해 컴퓨트 노드의 자동확장이 가능하고 Multi AZ를 지원하기 때문에 가용성도 확보할 수 있었습니다.<br>
<br>  
</details>
<details> 
  <summary><strong>4️⃣ Nat gateway, OpenVPN</strong></summary><br>
  Nat gateway는 프라이빗 서브넷에 위치한 ECS task 또는 Aurora 인스턴스에서 인터넷으로 향하는 Outbound 트래픽 경로를 열어주기 위해 사용되었고 일반적인 서비스 트래픽 처리에는 사용되지 않으나 DB 엔진 업데이트나 기타 외부와의 통신이 필요할 때 사용됩니다. 초기 NAT Gateway는 고강용성을 위해 Multi AZ로 구성하였으나 많은 비용이 발생했기에 1개 인스턴스로 축소하게 되었습니다. 또한 EC2 인스턴스에는 openVPN Access Sever가 구성이 되고 이는 개발자의 로컬 PC 환경이 VPC 안에 있는 것 처럼 동작하게 해줍니다. 우리 팀은 백엔드 코드 변경 시 Aurora와 연계하여 로컬에서 테스트가 필요했기 때문에 도입하게 되었습니다.<br>
<br>
</details>
<details> 
  <summary><strong>5️⃣ Secret Manager, Cognito</strong></summary><br>
  Secret Manager는 EC2 서버에 웹 콘솔로 접속하고 연결된 세션에 대한 감사에 목적으로 구성하였습니다. 또 다른 장점으로 EC2 서버에 SSH 접속할 때 필요한 포트나 키를 관리할 필요가 없어집니다. Cognito는 애플리케이션에 회원가입, 로그인 하는데 필요한 사용자 데이터베이스로 사용하게 됩니다.<br>
<br>  
</details>
<details> 
  <summary><strong>6️⃣ Task autoscaling 알람 slack</strong></summary><br>
  CloudWatch에서 ECS를 모니터링 하다가 일정한 임계치를 초과하는 CPU 사용률이 감지되면 Alarm을 활성화하고 해당하는 event는 SNS로 보내집니다. SNS로 보내진 메시지는 Lambda 함수를 호출하게 됩니다. Lambda는 Slack 채널에 발생한 event를 필터링하여 전달합니다.<br>
<br>  
</details>
<details> 
  <summary><strong>7️⃣ Grafana</strong></summary><br>
  CloudWatch Metrics과 Logs에 수집된 데이터를 소스로 Managed for Grafana 대시보드를 구성합니다. 대시보드에는 Aurora, ECS, WAF 등 다양한 Metircs과 Logs를 시각화합니다.<br>
<br>
</details>
<details> 
  <summary><strong>8️⃣ Route 53, codepipline</strong></summary><br>
  사용자는 Route53에서 DNS Lookup을 하고 CloudFront에 연결 요청합니다. CloudFront는 Frontend 페이지를 캐싱하고 WAF가 연결되어있어 다양한 webACL 규칙에 의거해 악의적인 패킷이 필터링됩니다. 또한 CloudFront 오리진은 S3 정적 웹사이트 호스팅 기능을 사용하였으며 프론트엔드 코드는 S3에 저장됩니다. AWS의 CodePipeline은 프로젝트 Github 리포지토리를 소스로 트리거됩니다.<br>
<br>  
</details>
<br>
<br>

## 📌 주요 기능

<details> 
  <summary><strong>Cognito를 이용한 회원가입,로그인<br></strong></summary><br>

![회원가입](https://user-images.githubusercontent.com/118946694/227525192-1cd2bd02-63b9-4a05-b3dd-f15a742c4940.gif)
 
 개발의 편의성을 위해 회원가입 및 로그인 인증을 AWS SDK를 이용해 Cognito를 이용해 백엔드에서 로직을 구현했으며 데이터베이스에는 회원가입한 유저의 정보를 저장하지않고 닉네임만을 저장합니다.
 또한 회원가입시 email과 닉네임을 받아서 로그인시 토큰을 발행하여 프론트로 보내게됩니다.
 
 ![crud구현](https://user-images.githubusercontent.com/118946694/227525266-75bf2ae7-4550-40b2-9dc4-147222ffa69d.gif)
 로그인한 회원은 글작성시 AWS SDK Cognito로 API요청을 보내게되면 닉네임이 리턴되며 닉네임을 통해 작성자를 구분하고 글을 수정, 삭제시 토큰을 통해 인증하게됩니다.
 


<br>  
</details>

<details> 
  <summary><strong>Terraform IaC 배포 아키텍처<br></strong></summary><br>

![Image](https://user-images.githubusercontent.com/106081707/227449823-cae7097a-b265-4bc0-8b33-afeea264ab6f.png)

  terraform을 협업하고 state 파일을 관리하기위해 terraform cloud를 사용했으며 각 백엔드 인프라와 프론트엔드 인프라, 테라폼 디렉토리를<br> WorkSpace마다 다르게 지정해주고, GitHub에 푸시하면 셋팅해놓은 변수를 이용해서 Plan을 실행하고,<br> 혹시 모를 충돌을 방지하기 위해 Apply는 수동으로 셋팅했습니다.


![Image](https://user-images.githubusercontent.com/106081707/227465023-d601ce8a-7c4d-47e2-a90c-d4720a31b100.png)
    
  
![Image](https://user-images.githubusercontent.com/106081707/227465713-ace168e6-b64b-4270-a0c8-e9fdfbf92121.png)


![Image](https://user-images.githubusercontent.com/106081707/227466523-7908f864-191f-4fb6-b81a-297a31117f27.png)
  aws 프로바이더를 사용 할 수있도록 aws 인증키를 env타입으로 세팅하고 terraform에서 사용될 민감 변수들은 terraform 타입으로 세팅했습니다.

<br>  
</details>
<details> 
  <summary><strong>Grafana를 이용한 시각화<br></strong></summary><br>

![Image](https://user-images.githubusercontent.com/106081707/227451614-a325a6b2-a34a-4d2a-84af-33d9131cefc6.png)

  모니터링할 대상으로 Aurora 데이터베이스, CloudFront, ALB, ECS 리소스에서 Metrics을 수집하고, ECS, Session Manager, WAF에서 Logs를 수집합니다.

### Metrics
---
#### Aurora에서 Query Throughput, Query Performance, Connections, Resource 사용량, Replica 관련 메트릭을 수집합니다.
![rds_metrics](https://user-images.githubusercontent.com/87158339/227463994-5da00a99-bfc9-4210-96a6-2d8576801b90.png)<br><br>

#### CloudFront에서 Errors와 Caching, 리소스 사용량 메트릭을 수집합니다.
![cloudfront_metrics](https://user-images.githubusercontent.com/87158339/227464269-f694f375-0306-43a4-a931-e275fc7034e1.png)<br><br>

#### ALB에서 Errors와 Latency, 리소스 사용량 메트릭을 수집합니다.
![elb_metrics](https://user-images.githubusercontent.com/87158339/227464428-12bf8a83-4a3d-486c-9cb4-96f5809225ae.png)<br><br>

#### ECS에서 service, 리소스 사용량 메트릭을 수집합니다.
![ecs_metrics](https://user-images.githubusercontent.com/87158339/227465470-a5b6e786-5712-4242-b510-0ac529758041.png)<br><br>

### Logs
---
#### ECS에서 200, 300, 400, 500 번대 응답, 요청 메시지를 수집하고 있습니다.
![ecs_logs](https://user-images.githubusercontent.com/87158339/227465855-4902a2ff-3bad-46b9-8b1b-fffa279a49eb.png)<br><br>

#### Session Manager에서 세션 정보를 수집하고 있습니다.
![sessionmansger_logs](https://user-images.githubusercontent.com/87158339/227465981-9c6aaa06-5a18-4885-9d06-a3ee389b80e8.png)<br><br>

#### WAF에서 국가별 트래픽과 차단 허용된 패킷의 개수, 그리고 차단된 패킷에 적용된 webACL을 확인할 수 있습니다.
![waf_logs](https://user-images.githubusercontent.com/87158339/225793713-4fc4c6b8-e1b6-4c6a-99d2-5c29be391eb3.png)<br><br>

### 수집 데이터
---
|리소스|데이터 유형|지표|
|:----|:--------:|:---|
|ECS|Metrics, Logs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|Metrics: Service, Utilization <br>Logs: Response, Request|
|Aurora|Metrics|Query Throughput, Query Performance, Connections, Utilization, Replica&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|
|CloudFront&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|Metrics|Errors, Caching|
|ALB|Metrics|Errors, Latency, Utilization|
|Session Manager|Logs|session|
|WAF|Logs|국가별 트래픽, 차단/허용 패킷 개수, 차단된 패킷에 적용된 rule|

<br>  
</details>

<br>
<br>

## 👪 TEAM 소개

|[박민혁](https://github.com/Park-Seaweed) 리더|[권광훈](https://github.com/gangdonguri)|[박예빈](https://github.com/yebinnn)|[김민지](https://github.com/si946bi)|
|:---:|:---:|:---:|:---:|
|<img src="https://img.shields.io/badge/DevOps-000000?style=for-the-badge&logo=&logoColor=white">|<img src="https://img.shields.io/badge/DevOps-000000?style=for-the-badge&logo=&logoColor=white">|<img src="https://img.shields.io/badge/DevOps-000000?style=for-the-badge&logo=&logoColor=white">|<img src="https://img.shields.io/badge/DevOps-000000?style=for-the-badge&logo=&logoColor=white">|
|![박민혁 미모티콘](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FzR6lR%2FbtrNjzHoynR%2FI4iKHEHRzPhXzKSm8xWxL0%2Fimg.png)|![권광훈 미모티콘](https://user-images.githubusercontent.com/87158339/227462281-977f1b83-211c-48b3-8f9f-c25a4f87b76b.png)|![박예빈 미모티콘](https://user-images.githubusercontent.com/119267181/227461192-be169932-94cf-40b0-a10b-b12fa7afa4bf.png)|![image](https://user-images.githubusercontent.com/119267181/227476007-c2bec33c-1950-4abf-b6f7-eaa1d218af93.png)|
|프론트 코드, 백엔드 코드 작업 및 백엔드 인프라 IaC |모니터링, CI/CD, <br>알림 시스템 IaC| CI/CD, 모니터링, 아키텍처 구성  |CI/CD, 프론트 IaC, 아키텍처 구성|
<br>

## 🔧 기술 스택

<br>
<br>

<p align="center">
<img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=Terraform&logoColor=white"> 
<img src="https://img.shields.io/badge/k6-7D64FF?style=for-the-badge&logo=k6&logoColor=white">
<img src="https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=Grafana&logoColor=white">
<img src="https://img.shields.io/badge/Amazon AWS-232F3E?style=for-the-badge&logo=Amazon AWS&logoColor=white">
<img src="https://img.shields.io/badge/GitHub Actions-2088FF?style=for-the-badge&logo=GitHub Actions&logoColor=white">
<img src="https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=Slack&logoColor=white">
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=JavaScript&logoColor=black">
<img src="https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=React&logoColor=black">
<img src="https://img.shields.io/badge/Fastify-000000?style=for-the-badge&logo=Fastify&logoColor=white">
<img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=MySQL&logoColor=white">
<img src="https://img.shields.io/badge/OpenVPN-EA7E20?style=for-the-badge&logo=OpenVPN&logoColor=white">



 </p>

 <br>
 <br>





## 🚀 트러블슈팅

- **[[Terraform] 백엔드 IaC](https://github.com/cs-devops-bootcamp/devops-03-Final-TeamA/issues/41)<br>**
- **[[ECR] InvalidSignatureException](https://github.com/cs-devops-bootcamp/devops-03-Final-TeamA/discussions/15)<br>**
- **[[ALB] Network Mappings](https://github.com/cs-devops-bootcamp/devops-03-Final-TeamA/discussions/16)<br>**
- **[[S3] bucket policy](https://github.com/cs-devops-bootcamp/devops-03-Final-TeamA/discussions/59)<br>**
- **[[openVPN] Client 연결 오류](https://github.com/cs-devops-bootcamp/devops-03-Final-TeamA/discussions/64)<br>**
- **[[CloudFront] S3 접근 제한](https://github.com/cs-devops-bootcamp/devops-03-Final-TeamA/discussions/66)<br>**
