import moment from "moment/moment";

const formatPrice = (string) => string.toLocaleString('en-US')

const formatDate = (date) => {
    if(!date) return null
    date = new Date(date)
    return `${date.getDate()}/${date.getMonth()+1}/${date.getFullYear()}`
}

export {formatPrice, formatDate}