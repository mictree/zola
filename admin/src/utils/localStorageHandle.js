export const getLocalStorage = (key) =>{
    const data = localStorage.getItem(key)
    if(data && data != 'undefined')
    {
        return JSON.parse(data)    
    }
    return null
}

export const setLocalStorage = (key, value) => {
    value = JSON.stringify(value)
    localStorage.setItem(key, value)
}

export const removeLocalStorage = (key) => {
    localStorage.removeItem(key)
}