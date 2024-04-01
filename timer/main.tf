resource "null_resource" "Batch1" {
}

resource "time_sleep" "wait30s" {
  depends_on = [null_resource.Batch1]
  create_duration = "30s"
}

resource "null_resource" "Last" {
  depends_on = [time_sleep.wait30s]
}

