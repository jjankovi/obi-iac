locals {
  public_subnet_ids = "subnet-02c075fa48f375e4e,subnet-0be93e0cea0a84244,subnet-06bcea42c2d25341e" # (nefunguje pre fargate profile)
  private_subnet_ids = ["subnet-05817cc08c4c95490", "subnet-0c23826ed22f9bec4", "subnet-0446f595633fdd966"]
  iam_admin_arn = "arn:aws:iam::396608792866:user/WorkloadAdministrator"
}