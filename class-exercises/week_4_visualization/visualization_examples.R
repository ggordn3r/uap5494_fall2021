# Here is the code with example visualizations that Dr. Sanchez presented during the Week 4 lecture.

library(tidyr)

apple_long <- gather(apple_data, date, distance, "2020-01-13":"2020-04-14", factor_key = TRUE)

apple_long

ggplot(apple_long, aes(x = distance, y = transportation_type))

ggplot(apple_long, aes(x = distance, y = transportation_type)) +
  geom_point()

ggplot(apple_long, aes(x = distance, y = transportation_type, color = transportation_type)) +
  geom_point()

ggplot(apple_long, aes(x = distance, y = transportation_type, color = transportation_type)) +
  geom_point() +
  labs(title = "Distance/Mode", x = "Distance", y = "Mode")

ggplot(apple_long, aes(x = distance, y = transportation_type, color = transportation_type)) +
  geom_point() +
  labs(title = "Distance/Mode", x = "Distance", y = "Mode") +
  scale_color_discrete(name = "Legend")

ggplot(apple_long, aes(x = distance, y = transportation_type, color = transportation_type)) +
  geom_point() +
  labs(title = "Distance/Mode", x = "Distance", y = "Mode") +
  scale_color_discrete(name = "Legend") +
  facet_wrap(~transportation_type, ncol = 3)