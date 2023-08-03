import { useQuery } from "@tanstack/react-query";
import statisticService from "../services/statisticService";

export const useStatisticNumber = () =>
  useQuery(["statistic-number"], statisticService.getInfo);

const transform = (data) => {
  const dataTmp = [
    { name: "1", Total: 0 },
    { name: "2", Total: 0 },
    { name: "3", Total: 0 },
    { name: "4", Total: 0 },
    { name: "5", Total: 0 },
    { name: "7", Total: 0 },
    { name: "8", Total: 0 },
    { name: "9", Total: 0 },
    { name: "10", Total: 0 },
    { name: "11", Total: 0 },
    { name: "12", Total: 0 },
  ];
  data.forEach((item) => {
    dataTmp.forEach((i) => {
      if (i.name === item.name) {
        i.Total = item.Total;
        return;
      }
    });
  });

  return dataTmp;
};

export const useSaleStatistic = () =>
  useQuery(["statistic-sale"], statisticService.getUserStatistic);

export const useStatisticUseAgeGroup = () =>
  useQuery(["user-age-group"], statisticService.getAgeStatistic);

export const useUserChatStatistic = (id) =>
  useQuery(
    ["user-chat-statistic", id],
    () => statisticService.getUserChatStatistic(id),
  );
