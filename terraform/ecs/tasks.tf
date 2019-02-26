data "aws_ecs_task_definition" "bookings" {
  depends_on      = ["aws_ecs_task_definition.bookings"]
  task_definition = "${aws_ecs_task_definition.bookings.family}"
}

resource "aws_ecs_task_definition" "bookings" {
  family                = "bookings"
  container_definitions = "${file("tasks-definitions/bookings.json")}"
}
