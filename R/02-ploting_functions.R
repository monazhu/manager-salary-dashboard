plot_world_map <- function(data){
  data|> 
    group_by(country_cleaned) |> 
    summarise(Count = n()) |> 
    base::merge(world, by.x = "country_cleaned", by.y = "region", all.y = T) |> 
    arrange(group, order) |> 
    ggplot(aes(x = long, y = lat, group = group, fill = Count, label = Count)) + 
    geom_polygon(color = "white", size = 0.2) +
    theme_minimal() +
    theme(axis.text = element_blank(),
          axis.title = element_blank(),
          panel.grid = element_blank()) + 
    scale_fill_gradientn(trans = "log",
                         colours = wes_palettes$GrandBudapest1[c(1,2,3)],
                         na.value = "gray90") + 
    guides(fill = "none") +
    ggtitle("World Map") + 
    coord_cartesian(ylim = c(-50, 90)) 
}


plot_salary <- function(data){
  data|>
    pivot_longer(c(salary_adj, total_comp_adj), names_to = "salary", values_to = "dollar") |> 
    ggplot(aes(x = salary, y = dollar, fill = salary)) +
    geom_violinhalf() +
    scale_y_continuous(labels = scales::dollar_format(prefix="$"),
                       limits=c(0, 1000000)) +
    scale_x_discrete("", limits=c("total_comp_adj", "salary_adj"),
                     labels = c("Total Annual\nCompensation",
                                "Annual Salary")) + 
    geom_boxplot(width = 0.12, position= position_nudge(x=-.15),
                 show.legend = FALSE) + 
    guides(fill = FALSE) + 
    scale_fill_manual(values = wes_palette("GrandBudapest1")) + 
    theme_bw() + 
    theme(plot.margin = unit(c(0.5,1,0.5,0),"cm")) + 
    labs(
      title = "Annual Salary and Total Compensation",
      y = "US Dollars"
    ) + 
    coord_flip() 
}


plot_gender_ratio <- function(data){
  data|>
    group_by(gender) |> 
    summarise(count = n()) |> 
    ungroup() |> 
    mutate(prop = count/sum(count)) |> 
    ggplot(aes(x = "", y = prop, fill = gender)) + 
    geom_bar(stat="identity") + 
    scale_fill_manual("", values = gender_cols) + 
    scale_x_discrete("") + 
    scale_y_continuous("Percentage", labels = scales::percent_format()) + 
    geom_shadowtext(aes(label = paste0(round(prop*100, 1), "%")),
                    position = position_stack(vjust = 0.5),
                    color = "black", size = 14 / .pt, 
                    fontface = "bold", bg.colour = "white", bg.r = .2) +
    theme_minimal() +
    theme(plot.margin = unit(c(0.5,1,0.5,1),"cm")) + 
    ggtitle("Gender Breakdown") + 
    theme(legend.position="bottom")
}