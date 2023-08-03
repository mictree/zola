import "./home.scss";
import Widget from "../../components/widget/Widget";
import Chart from "../../components/chart/Chart";
import {
  useSaleStatistic,
  useStatisticNumber,
  useStatisticUseAgeGroup,
} from "../../hooks/useStatisticNumber";
import PieChartCustom from "../../components/chart/PieChartCustom";
import { useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import statisticService from "../../services/statisticService";

const Home = () => {
  const { data: statistic } = useStatisticNumber();
  const { data: saleByMonth } = useSaleStatistic();
  const { data: ageGroup } = useStatisticUseAgeGroup();
  const { data: postData } = useQuery(
    ["post-by-month"],
    statisticService.getPostStatistic
  );

  useEffect(() => {
    document.title = "Home - Admin";
  }, []);

  return (
    <div className="home">
      {/* <Sidebar /> */}
      <div className="homeContainer">
        {/* <Navbar /> */}
        <div className="widgets">
          <Widget type="user" amount={statistic?.data.userNumber} />
          <Widget type="post" amount={statistic?.data.postNumber} />
          <Widget type="chat" amount={statistic?.data.chatNumber} />
          <Widget type="room" amount={statistic?.data.roomNumber} />
          <Widget type="comment" amount={statistic?.data.commentNumber} />
        </div>
        <div className="charts">
          {/* <Featured /> */}
          <Chart
            title={"User Register in last 6 month"}
            aspect={2 / 1}
            data={saleByMonth?.data}
          />
          <PieChartCustom data={ageGroup?.data} />
        </div>
        <div className="charts">
          <Chart
            title={"Post in last 6 month"}
            aspect={4 / 1}
            data={postData?.data}
          />
        </div>
        {/* <div className="listContainer">
          <div className="listTitle">Latest Transactions</div>
          <Table />
        </div> */}
      </div>
    </div>
  );
};

export default Home;
